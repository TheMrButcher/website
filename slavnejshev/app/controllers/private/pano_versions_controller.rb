class Private::PanoVersionsController < ApplicationController
  include Private::SessionsHelper
  Panorama = Private::Panorama
  PanoVersion = Private::PanoVersion
  
  before_action :logged_in_user, only: [:create, :update]
  before_action :has_right_to_create, only: [:create]
  before_action :has_right_to_update, only: [:update]
  
  def create
    next_index = 1
    unless @panorama.versions.empty?
      next_index = @panorama.versions.maximum("idx") + 1
    end
    @panorama.versions.create!(idx: next_index)
    redirect_to private_show_pano_version_path(@panorama, next_index)
  end
  
  def update
    if @pano_version.config.nil? && params[:private_pano_version][:config].present?
      config_io = params[:private_pano_version][:config]
      config_datum = config_io.read
      config_hash = Private::Datum.digest(config_datum)
      config_name = config_io.original_filename
      datum = Private::Datum.find_by(datum_hash: config_hash)
      if datum.nil?
        path = Rails.root.join('storage', 'pano', config_hash)
        datum = Private::Datum.create!(path: path, datum_hash: config_hash)
        FileUtils::mkdir_p Rails.root.join('storage', 'pano')
        File.open(path, 'wb') do |file|
          file.write(config_datum)
        end
      end
      config_key = "pano/" + @pano_version.id.to_s + "/" + config_name
      config = datum.files.create(original_name: config_name, key: config_key)
      @pano_version.update_attributes(config: config)
    end
    redirect_to private_show_pano_version_path(@panorama, @pano_version.idx)
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
