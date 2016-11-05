module Private::PanoramasHelper
  def pano_title(pano, version = nil)
    title = t('private.panoramas.show.obj_name') + " " + pano.full_path
    if version.nil?
      title
    else
      title + " #" + version.idx.to_s
    end
  end
end
