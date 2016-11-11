class Private::PanoramasController < ApplicationController
  layout 'private/layout'
  
  include Private::SessionsHelper
  Panorama = Private::Panorama
  
  before_action :logged_in_user, only: [:create, :update]
  before_action :has_right_to_see, only: [:show, :image]
  before_action :has_right_to_create, only: [:create]
  before_action :has_right_to_update, only: [:update]
  
  def show
    calc_version
  end
  
  def image
    calc_version || not_found
    key = 'pano/' + @version.id.to_s + '/images/' + params[:image_name]
    key += "." + params[:format] unless params[:format].nil? 
    redirect_to private_show_datum_path(key)
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
        redirect_to private_files_path(@folder)
      end
    end
  end
  
  def update
    panorama_params = params.require(:private_panorama).permit(:description, :title)
    @panorama.update_attributes(panorama_params)
    redirect_to private_show_pano_path(@panorama)
  end
  
  private
    def calc_version
      version_index = params[:version]
      if version_index.nil?
        unless @panorama.versions.empty?
          @version = @panorama.versions.last
        end
      else
        @version = @panorama.versions.find_by(idx: version_index)
      end
      return @version
    end
  
    def has_right_to_see
      @panorama = Panorama.find_by(full_path: params[:id])
      check_right_to_see(@panorama.folder)
    end
    
    def has_right_to_create
      @folder = Folder.find_by(id: params[:private_panorama][:folder_id])
      has_right_to_change_files_in(@folder)
    end
    
    def has_right_to_update
      @panorama = Panorama.find(params[:id])
      has_right_to_change_files_in(@panorama.folder)
    end
end
