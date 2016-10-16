class Private::FoldersController < ApplicationController
  include Private::SessionsHelper
  
  before_action :logged_in_user
  before_action :admin_user, only: [:new, :index]
  before_action :admin_or_owner, only: [:show]
  before_action :has_right_to_create, only: [:create]
  
  def new
    @folder = Folder.new
  end
  
  def create
    @parent = Folder.find_by(id: params[:private_folder][:parent_id])
    owner = User.find_by(name: params[:private_folder][:owner])
    if owner.nil?
      flash[:danger] = t(:no_such_user)
      redirect_to_parent_or private_roots_new_path
      return
    end
    @folder = Folder.new(
      name: params[:private_folder][:name],
      parent_id: params[:private_folder][:parent_id],
      owner_id: owner.id)
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
    def admin_or_owner
      @folder = Folder.find_by(full_path: params[:id])
      admin_or_owner_of(@folder)
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
