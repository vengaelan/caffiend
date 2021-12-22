require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

class MeetingsController < ApplicationController
  CALENDAR_ID = 'primary'

  # NEW => GET /users/:id (As a user, I can create a new meeting)
  def new
    @meeting = Meeting.new
  end

  # CREATE => GET /users/:id (As a user, I can create a new meeting + Send a google event w notif)
  def create
    # client = get_google_calendar_client current_user

    # Named params are retrieved form params and not meeting params. Found out through raise. Need to check with TA.
    @meeting = Meeting.new()
    @meeting.location = meeting_params[:location]
    @meeting.start_datetime = params[:date] + " " + params[:start_time]
    @meeting.end_datetime = params[:date] + " " + params[:end_time]
    @meeting.user = current_user
    @meeting.save!

    # event = get_event(@meeting)
    # client.insert_event('primary', event, send_updates: "all")
    flash[:notice] = 'You successfully created a new meeting!'

    redirect_to send_invite_meeting_path(@meeting)
  end

  def update
    @meeting = Meeting.find(params[:id])

    if !@meeting.invitee_email
      @meeting.update(invitee_email: meeting_params[:invitee_email], status: "ACCEPTED")
      client = get_google_calendar_client(@meeting.user)
      event = get_event(@meeting)
      client.insert_event('primary', event, send_updates: "all")
    end

    redirect_to meeting_path
  end

  # SHOW => GET /meetings/:id (As a user, I can generate a meeting invite link/ view meeting)
  def show
    @meeting = Meeting.find(params[:id])
  end

  # CAFFIEND CREATED ACTIONS

  # UPCOMING => GET /users/:id (As a user, I can view my upcoming meetings)
  def upcoming
    start_date = params.fetch(:start_date, Date.today).to_date
    @upcoming_meetings = Meeting.where(start_datetime: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week, status: ["ACCEPTED", "PENDING"])
  end

  # PAST => GET /users/:id (As a user, I can view my past meetings)
  def past
    past_meetings = Meeting.where(status: "COMPLETED")
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

  def send_invite
    @meeting = Meeting.find(params[:id])
  end

  private

  # STRONG PARAMS
  def meeting_params
    params.require(:meeting).permit(:date, :start_time, :end_time, :location, :invitee_email) # Need to require named parameters from simple form
  end


  def get_event meeting
    attendees = [{ email: meeting.invitee_email }] # task[:members].split(',').map{ |t| {email: t.strip} }
    event = Google::Apis::CalendarV3::Event.new({
      summary: 'CAFFIEND SESSION',
      location: meeting.location,
      description: meeting.location,
      start: {
        date_time: meeting.start_datetime.iso8601, #Time.new(meeting.start_datetime).to_datetime.rfc3339,
        time_zone: "Asia/Singapore"
        # date_time: '2019-09-07T09:00:00-07:00',
        # time_zone: 'Asia/Kolkata',
      },
      end: {
        date_time: meeting.end_datetime.iso8601, #Time.new(meeting.end_datetime).to_datetime.rfc3339,
        time_zone: "Asia/Singapore"
      },
      attendees: attendees,
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
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
  end

end
