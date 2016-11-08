module Private::PanoramasHelper
  def pano_title(pano, version = nil)
    title = pano.readable_name
    if version.nil?
      title
    else
      title + " #" + version.idx.to_s
    end
  end
end
