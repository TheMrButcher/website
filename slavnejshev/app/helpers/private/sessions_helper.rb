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
      require_logging_in      
    end
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def require_logging_in
    flash[:danger] = t(:logging_in_required)
    redirect_to private_login_path
  end
    
  def admin_user
    unless current_admin?
      flash[:danger] = t(:access_denied)
      redirect_to current_user
    end
  end
  
  def check_right_to_see(obj)
    unless obj.nil? || obj.public?
      if logged_in?
        admin_or_owner_of(obj)
      else
        require_logging_in
      end
    end
  end
  
  def admin_or_owner_of?(folder)
    current_user?(folder.owner) || current_admin?
  end
  
  def admin_or_owner_of(folder)
    unless folder.nil? || current_user?(folder.owner)
      admin_user
    end
  end
  
  def redirect_to_folder_or(folder, path)
    if folder.nil?
      redirect_to path
    else
      redirect_to private_files_path(folder)
    end
  end
  
  def has_right_to_change_files_in(folder)
    unless folder.nil?
      if folder.stores_panoramas?
        admin_or_owner_of(folder)
      else
        flash[:danger] = t(:access_denied)
        redirect_to private_files_path(folder)
      end
    end
  end
end
