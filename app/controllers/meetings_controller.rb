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
    @meeting = Meeting.new(meeting_params)
    @meeting.user = current_user
    @meeting.save!

    redirect_to user_path(current_user)
  end

  # UPCOMING => GET /users/:id (As a user, I can view my upcoming meetings)
  def upcoming
    @upcoming_meetings = Meeting.where(status: "ACCEPTED")
  end

  # PAST => GET /users/:id (As a user, I can view my past meetings)
  def past
    past_meetings = Meeting.where(status: "COMPLETED")
  end

  private

  # STRONG PARAMS
  def meeting_params
    params.require(:meeting).permit(:start_datetime, :end_datetime, :location)
  end
end
