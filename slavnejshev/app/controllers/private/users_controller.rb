class Private::UsersController < ApplicationController
  include Private::SessionsHelper
  
  before_action :logged_in_user
  before_action :admin_or_correct_user, only: [:show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index]
  
  def show
    @user = find_user
  end

  def index
  end

  def edit
  end
  
  def update
  end
  
  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = t(:logging_in_required)
        redirect_to private_login_path
      end
    end
    
    def correct_user
      @user = find_user
      unless current_user?(@user)
        flash[:danger] = t(:access_denied)
        redirect_to current_user
      end
    end
    
    def admin_user
      unless current_admin?
        flash[:danger] = t(:access_denied)
        redirect_to current_user
      end
    end
    
    def admin_or_correct_user
      unless current_admin?
        correct_user
      end
    end
    
    def find_user
      User.friendly.find(params[:id])
    end
end
