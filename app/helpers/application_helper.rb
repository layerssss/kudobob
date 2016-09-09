module ApplicationHelper
  def admin?
    current_user.try(&:admin?)
  end
end
