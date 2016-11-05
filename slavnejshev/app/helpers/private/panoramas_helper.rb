module Private::PanoramasHelper
  def pano_title(pano, version)
    title = pano.full_path
    if version.nil?
      title
    else
      title + " #" + version.idx.to_s
    end
  end
end
