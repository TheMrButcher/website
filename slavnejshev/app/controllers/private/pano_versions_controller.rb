class Private::PanoVersionsController < ApplicationController
  include Private::SessionsHelper
  include Private::DataHelper
  Panorama = Private::Panorama
  PanoVersion = Private::PanoVersion
  
  before_action :logged_in_user, only: [:create, :update, :destroy]
  before_action :has_right_to_create, only: [:create]
  before_action :has_right_to_update, only: [:update, :destroy]
  
  MEMBERS = {config: :pano_config, tiles: :pano_tile, hotspots: :pano_hotspot_image}
  
  def create
    next_index = 1
    unless @panorama.versions.empty?
      next_index = @panorama.versions.maximum("idx") + 1
    end
    @panorama.versions.create!(idx: next_index)
    redirect_to private_show_pano_version_path(@panorama, next_index)
  end
  
  def update
    if params.key?(:private_pano_version)
      pano_version_params = params.require(:private_pano_version).permit(:description)
      @pano_version.update_attributes(pano_version_params)
      if @pano_version.config.nil? && params[:private_pano_version][:config].present?
        config_io = params[:private_pano_version][:config]
        make_pano_file(config_io.original_filename, config_io.read, :pano_config)
      end
      if @pano_version.tiles.empty? && params[:private_pano_version][:tiles].present?
        unzip_pano_archive(params[:private_pano_version][:tiles], :pano_tile)
      end
      if @pano_version.hotspots.empty? && params[:private_pano_version][:hotspots].present?
        unzip_pano_archive(params[:private_pano_version][:hotspots], :pano_hotspot_image)
      end
    end
    
    MEMBERS.each do |member_name, file_type|
      param = params[member_name.to_s + "_src"]
      if param.present? && @pano_version.send(member_name).blank?
        src_version = PanoVersion.find(param)
        copy_files(src_version, @pano_version, file_type)
      end
    end
      
    if @pano_version.config.nil? && params[:config_src].present?
      
    end
    
    redirect_to private_show_pano_version_path(@panorama, @pano_version.idx)
  end
  
  def destroy
    @pano_version.destroy
    redirect_to private_show_pano_path(@panorama)
  end
  
  private
    def has_right_to_create
      @panorama = Panorama.find_by(id: params[:panorama_id])
      has_right_to_update_panorama
    end
    
    def has_right_to_update
      @pano_version = PanoVersion.find_by(id: params[:id])
      @panorama = @pano_version.panorama unless @pano_version.nil?
      has_right_to_update_panorama
    end
    
    def has_right_to_update_panorama
      if @panorama.nil?
        flash[:danger] = t(:access_denied)
        redirect_to current_user
      else
        has_right_to_change_files_in(@panorama.folder)
      end
    end
end
