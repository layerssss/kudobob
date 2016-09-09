class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def authenticate_admin!
    return redircet_to :back, alert: 'Thou shall enroll as an admin before doing that!' unless current_user.try(&:admin?)
  end
end
