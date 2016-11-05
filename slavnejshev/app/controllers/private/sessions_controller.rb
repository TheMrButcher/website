class Private::SessionsController < ApplicationController
  layout 'private/layout'
  
  include Private::SessionsHelper
  
  def new
  end
  
  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = t(:bad_name_password_pair)
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to private_login_path
  end
end
