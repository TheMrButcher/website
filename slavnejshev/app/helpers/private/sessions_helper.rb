module Private::SessionsHelper
  User = Private::User
  Folder = Private::Folder
  
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
  
  def logged_in_user
    unless logged_in?
      flash[:danger] = t(:logging_in_required)
      redirect_to private_login_path
    end
  end
    
  def admin_user
    unless current_admin?
      flash[:danger] = t(:access_denied)
      redirect_to current_user
    end
  end
end
