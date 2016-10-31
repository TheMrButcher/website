class Private::DataController < ApplicationController
  include Private::SessionsHelper
  
  before_action :has_right_to_see, only: [:show]
  
  def show
    send_file(@file.datum.path, filename: @file.original_name)
  end
  
  private
    def has_right_to_see
      key = params[:id]
      key += "." + params[:format] unless params[:format].nil? 
      @file = Private::File.find_by(key: key) or not_found
      if @file.file_type.in? [ 'pano_config', 'pano_tile', 'pano_hotspot_image' ]
        panoVersion = @file.storage
        check_right_to_see(panoVersion.panorama.folder)        
      end
    end
end
