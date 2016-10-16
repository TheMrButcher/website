class Private::UsersController < ApplicationController
  include Private::SessionsHelper
  
  before_action :logged_in_user
  before_action :admin_or_correct_user, only: [:show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :new, :create, :destroy]
  
  def show
    @user = find_user
  end

  def index
    @users = User.all
  end

  def edit
  end
  
  def update
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t(:created_user)
      redirect_to private_users_path
    else
      flash[:danger] = t(:wrong_user_params)
      redirect_to new_private_user_path
    end
  end
  
  private
    def correct_user
      @user = find_user
      unless current_user?(@user)
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
    
    def user_params
      params.require(:private_user).permit(:name, :email, :password, :password_confirmation)
    end
end
