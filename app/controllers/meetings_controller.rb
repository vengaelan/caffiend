class MeetingsController < ApplicationController
  # SHOW => GET /meetings/:id (As a user, I can generate a meeting invite link/ view meeting)
  def show
    @meeting = Meeting.find(params[:id])
  end

  # NEW => GET /users/:id (As a user, I can create a new meeting)
  def new
    @meeting = Meeting.new
  end

  # CREATE => GET /users/:id (As a user, I can create a new meeting)
  def create
    @meeting = Meeting.new()
    @meeting.location = meeting_params[:location]
    @meeting.start_datetime = params[:date] + " " + params[:start_time] # Named params are retrieved form params and not meeting params. Found out through raise. Need to check with TA.
    @meeting.end_datetime = params[:date] + " " + params[:end_time]
    @meeting.user = current_user
    @meeting.save!
    redirect_to user_path(current_user)
  end

  # UPCOMING => GET /users/:id (As a user, I can view my upcoming meetings)
  def upcoming
    start_date = params.fetch(:start_date, Date.today).to_date

    @upcoming_meetings = Meeting.where(start_datetime: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week, status: "ACCEPTED")
  end

  # PAST => GET /users/:id (As a user, I can view my past meetings)
  def past
    past_meetings = Meeting.where(status: "COMPLETED")
  end

  private

  # STRONG PARAMS
  def meeting_params
    params.require(:meeting).permit(:date, :start_time, :end_time, :location) # Need to require named parameters from simple form
  end
end
