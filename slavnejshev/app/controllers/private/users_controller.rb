class Private::UsersController < ApplicationController
  include Private::SessionsHelper
  
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update]
  
  def show
    @user = User.find_by(id: params[:id])
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
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = t(:access_denied)
        redirect_to current_user
      end
    end
end
