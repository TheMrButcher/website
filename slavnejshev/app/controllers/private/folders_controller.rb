class Private::FoldersController < ApplicationController
  include Private::SessionsHelper
  
  before_action :logged_in_user, only: [:new, :index, :create]
  before_action :admin_user, only: [:new, :index]
  before_action :has_right_to_see, only: [:show]
  before_action :has_right_to_create, only: [:create]
  
  def new
    @folder = Folder.new
  end
  
  def create
    folder_params = params.require(:private_folder).permit(:name, :parent_id, :public, :stores_panoramas)
    @folder = Folder.new(folder_params)
    @folder.owner = User.find_by(name: params[:private_folder][:owner])
    if @folder.save
      flash[:success] = t(:created_folder)
      redirect_to_parent_or private_roots_path
    else
      flash[:danger] = t(:wrong_folder_params)
      redirect_to_parent_or private_roots_new_path
    end
  end

  def show
    @folder = Folder.find_by(full_path: params[:id])
  end

  def index
    @folders = Folder.roots
  end
  
  private
    def has_right_to_see
      @folder = Folder.find_by(full_path: params[:id])
      unless @folder.nil? || @folder.public?
        if logged_in?
          admin_or_owner_of(@folder)          
        else
          require_logging_in
        end
      end
    end
    
    def has_right_to_create
      @parent = Folder.find_by(id: params[:private_folder][:parent_id])
      if @parent.nil?
        admin_user
      else
        if @parent.owner.name == params[:private_folder][:owner]
          admin_or_owner_of(@parent)
        else
          flash[:danger] = t(:access_denied)
          redirect_to current_user
        end
      end
    end
    
    def admin_or_owner_of(folder)
      unless folder.nil? || current_user?(folder.owner)
        admin_user
      end
    end
  
    def redirect_to_parent_or(path)
      if @parent.nil?
        redirect_to path
      else
        redirect_to private_files_path(@parent)
      end
    end
end
