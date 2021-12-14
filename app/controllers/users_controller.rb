class UsersController < ApplicationController
  # SHOW => GET /users/:id (Dashboard)
  def show
    @user = User.find(params[:id])
  end
end
