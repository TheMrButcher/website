require 'test_helper'

class Private::DestroyPanoTest < ActionDispatch::IntegrationTest
  def setup
    @first = private_users(:first)
    @pano_folder = Private::Folder.new(name: "folder", owner_id: @first.id, stores_panoramas: true)
    @pano_folder.save
    @panorama = @pano_folder.panoramas.create(name: "panorama")
  end
  
  test "associated versions are destroyed" do
    @panorama.versions.create(idx: 1)
    @panorama.versions.create(idx: 2)
    assert_difference 'Private::PanoVersion.count', -2 do
      @panorama.destroy
    end
  end
  
  test "associated files are destroyed on version destruction" do
    version = @panorama.versions.create(idx: 1)
    datum = Private::Datum.create!(path: 'hij', datum_hash: 'hij')
    datum.files.create(
      original_name: 'tile', key: 'tile', storage: version, file_type: :pano_tile)
    assert_difference 'Private::File.count', -1 do
      version.destroy
    end
  end
  
  test "associated files are destroyed on full pano destruction" do
    version = @panorama.versions.create(idx: 1)
    datum = Private::Datum.create!(path: 'hij', datum_hash: 'hij')
    datum.files.create(
      original_name: 'config', key: 'config', storage: version, file_type: :pano_config)
    datum.files.create(
      original_name: 'tile', key: 'tile', storage: version, file_type: :pano_tile)
    datum.files.create(
      original_name: 'hotspot', key: 'hotspot', storage: version, file_type: :pano_hotspot_image)
    assert_difference 'Private::File.count', -3 do
      @panorama.destroy
    end
  end
end
