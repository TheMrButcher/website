module Private::SessionsHelper
  User = Private::User
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def current_user?(user)
    current_user == user
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def current_admin?
    current_user && current_user.admin?
  end
end
