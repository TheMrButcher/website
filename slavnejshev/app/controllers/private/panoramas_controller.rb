class Private::PanoramasController < ApplicationController
  include Private::SessionsHelper
  Panorama = Private::Panorama
  
  before_action :logged_in_user, only: [:create]
  before_action :has_right_to_see, only: [:show]
  before_action :has_right_to_create, only: [:create]
  
  def show
  end
  
  def create
    panorama_params = params.require(:private_panorama).permit(:name, :folder_id)
    @panorama = Panorama.new(panorama_params)
    if @panorama.save
      flash[:success] = t(:created_panorama)
      redirect_to private_show_pano_path(@panorama)
    else
      flash[:danger] = t(:wrong_panorama_params)
      if @folder.nil?
        redirect_to current_user
      else
        redirect_to private_files_path(folder)
      end
    end
  end
  
  private
    def has_right_to_see
      @panorama = Panorama.find_by(full_path: params[:id])
      check_right_to_see(@panorama.folder)
    end
    
    def has_right_to_create
      @folder = Folder.find_by(id: params[:private_panorama][:folder_id])
      unless @folder.nil?
        if @folder.stores_panoramas?
          admin_or_owner_of(@folder)
        else
          flash[:danger] = t(:access_denied)
          redirect_to private_files_path(@folder)
        end
      end
    end
end
