class UsersController < ApplicationController
  # SHOW => GET /users/:id (Dashboard)
  before_action :set_user, only: %i[show edit update]

  def show
  end

  def edit
  end

  def update
    @user = current_user
    @user.update(user_params)

    respond_to do |format|
      format.html { redirect_to user_path }
      format.text { render partial: 'users/user_info', locals: { user: @user }, formats: [:html] }
    end
  end

  private

  def user_params
    params.require(:user).permit(:about, :description, :photo)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
