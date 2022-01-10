class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :configure_permitted_parameters, if: :devise_controller?


  private

  def configure_permitted_parameters # Remember to update keys if user model is updated
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :photo])
  end
end
