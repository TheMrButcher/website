class Private::PanoVersionsController < ApplicationController
  include Private::SessionsHelper
  Panorama = Private::Panorama
  
  before_action :logged_in_user, only: [:create]
  before_action :has_right_to_create, only: [:create]
  
  def create
    next_index = 1
    unless @panorama.versions.empty?
      next_index = @panorama.versions.maximum("idx") + 1
    end
    @panorama.versions.create!(idx: next_index)
    redirect_to private_show_pano_version_path(@panorama, next_index)
  end
  
  private  
    def has_right_to_create
      @panorama = Panorama.find_by(id: params[:panorama_id])
      unless @panorama.nil?
        has_right_to_change_files_in(@panorama.folder)
      end
    end
end
