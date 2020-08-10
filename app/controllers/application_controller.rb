class ApplicationController < ActionController::Base
  # CSRF(クロスサイトリクエストフォージェリ) 対策
  protect_from_forgery
  # before_action :authenticate_user!, only: [:index, :update, :show, :destory]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
