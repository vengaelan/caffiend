require "google/apis/calendar_v3"
require "google/api_client/client_secrets"
require "securerandom"

class MeetingsController < ApplicationController
  CALENDAR_ID = 'primary'

  # NEW => GET /users/:id (As a user, I can create a new meeting)
  def new
    @meeting = Meeting.new
    #3.times { @meeting.choices.build }
    @meeting.choices.build
  end

  # CREATE => GET /users/:id (As a user, I can create a new meeting + Send a google event w notif)
  def create
    # client = get_google_calendar_client current_user

    @meeting = Meeting.new(meeting_params)

    # If only 1 choice, meeting model updated with choice attributes
    if @meeting.choices.length == 1
      choice = @meeting.choices.first
      @meeting.start_datetime = choice.start_datetime
      @meeting.end_datetime = choice.end_datetime
      @meeting.location = choice.location
    end
    # Named params are retrieved form params and not meeting params. Found out through raise. Need to check with TA.
    # @meeting.location = meeting_params[:location]
    # @meeting.start_datetime = params[:date] + " " + params[:start_time]
    # @meeting.end_datetime = params[:date] + " " + params[:end_time]

    # @meeting.user = current_user

    # Removed named parameters, choices' attributes can be instatinated on line 17.
    # loop through choices hash and create new choice
    # meeting_params[:choices_attributes].each_value do |value|
    #   @meeting.choices.build(value)
    # end

    @meeting.save!
    @meeting_user = MeetingUser.new()
    @meeting_user.user = current_user
    @meeting_user.meeting = @meeting
    @meeting_user.host = true
    @meeting_user.save!

    flash[:notice] = 'You successfully created a new meeting!'

    redirect_to copy_invite_meeting_path(@meeting)
  end

  def update
    @meeting = Meeting.find(params[:id])
    @host = MeetingUser.where(meeting: @meeting, host: true).first.user
    # if meeting_params[:invitee_email] == ""
    #   redirect_to root
    # end
    @meeting.update(meeting_params.except(:invitee_email))
    @meeting.invitee_email << meeting_params[:invitee_email]
    if @meeting.save
      @meeting.update(status: "ACCEPTED")
      if User.find_by_email(@meeting.invitee_email.last)
        add_meeting_to_existing_user(@meeting.invitee_email.last, @meeting)
      else
        add_meeting_to_non_user(@meeting.invitee_email.last, @meeting)
      end

      client = get_google_calendar_client(@host)
      event_id = "caffiendv2#{MeetingUser.where(meeting: @meeting, host: true).first.id}"

      if @meeting.meeting_link
        event = client.get_event('primary', event_id)
        event.attendees << { email: @meeting.invitee_email.last }
        client.update_event('primary', event.id, event, send_updates: "all")
      else
        event = get_event(@meeting)
        client.insert_event('primary', event, send_updates: "all", conference_data_version: "1")
        meet_link = client.get_event('primary', event_id).hangout_link
        @meeting.update(meeting_link: meet_link)
      end

      redirect_to meeting_confirmation_meeting_path(@meeting)
    else
      render "send_invite"
    end
  end

  # SHOW => GET /meetings/:id (As a user, I can generate a meeting invite link/ view meeting)
  def show
    @meeting = Meeting.find(params[:id])
  end

  # -------------------- CAFFIEND CREATED ACTIONS --------------------

  # UPCOMING => GET /users/:id (As a user, I can view my upcoming meetings)
  def upcoming
    start_date = params.fetch(:start_date, Date.today).to_date
    @upcoming_meetings = current_user.meetings.where(start_datetime: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week, status: ["ACCEPTED", "PENDING"])
  end

  # PAST => GET /users/:id (As a user, I can view my past meetings)
  def past
    past_meetings = current_user.meetings.where(status: "COMPLETED")
  end


  # Google Calendar Client Method
  def get_google_calendar_client current_user
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present? && current_user.token.present? && current_user.refresh_token.present?)
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "token" => current_user.token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => ENV["GOOGLE_API_KEY"],
        "client_secret" => ENV["GOOGLE_API_SECRET"]
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          token: client.authorization.token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
    end
    client
  end

  def copy_invite
    @meeting = Meeting.find(params[:id])
  end

  def send_invite
    @meeting = Meeting.find(params[:id])
  end

  def meeting_confirmation
    @meeting = Meeting.find(params[:id])
  end

  private

  # STRONG PARAMS
  def meeting_params
    params
     .require(:meeting)
     .permit(:start_datetime, :end_datetime, :location, :invitee_email,
             choices_attributes: [:id, :start_datetime, :end_datetime, :location, :_destroy])
  end

  # Google API Get Event Method
  def get_event meeting
    attendees = [{ email: meeting.invitee_email.last }] # task[:members].split(',').map{ |t| {email: t.strip} }
    event = Google::Apis::CalendarV3::Event.new({
      summary: 'CAFFIEND SESSION',
      location: meeting.location,
      description: meeting.location,
      id: "caffiendv2#{MeetingUser.where(meeting: meeting, host: true).first.id}",
      color_id: '3',
      start: {
        date_time: meeting.start_datetime.iso8601,
        time_zone: "Asia/Singapore"
      },
      end: {
        date_time: meeting.end_datetime.iso8601,
        time_zone: "Asia/Singapore"
      },
      attendees: attendees,
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: "popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: "email", minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
                        {type: 'event_creation', method: 'email'},
                        {type: 'event_change', method: 'email'},
                        {type: 'event_cancellation', method: 'email'},
                        {type: 'event_response', method: 'email'},
                       ]
      }, 'primary': true
    })

    if meeting.meeting_link
      event.hangout_link = meeting.meeting_link
    else
      event.conference_data = {
        create_request: {
          conference_solution_key: {
            type: 'hangoutsMeet'
          }, request_id: SecureRandom.uuid
        }
      }
    end
    event
  end

  def add_meeting_to_existing_user(email, meeting)
    @meeting_user = MeetingUser.new
    @meeting_user.meeting = meeting
    @meeting_user.user = User.find_by_email(email)
    @meeting_user.save!
  end

  def add_meeting_to_non_user(email, meeting)
    @non_meeting_user = MeetingNonUser.new
    @non_meeting_user.meeting = meeting
    @non_meeting_user.non_user_email = email
    @non_meeting_user.save!
  end

end
