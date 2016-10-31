require 'test_helper'

class Private::PanoFilesUploadingTest < ActionDispatch::IntegrationTest
  def setup
    @first = private_users(:first)
    @pano_version = private_pano_versions(:first_pub_pano_version)
  end
  
  test 'successfull tiles loading' do
    log_in_as(@first)
    tiles = fixture_file_upload('test/fixtures/private/files/archive.zip', 'application/zip', binary: true)
    assert_difference 'Private::Datum.count', 3 do
      patch private_pano_version_path(@pano_version), params: { private_pano_version: { tiles: tiles } }
    end
    assert_redirected_to private_show_pano_version_path(@pano_version.panorama, @pano_version.idx)
    @pano_version.reload
    assert_equal 3, @pano_version.tiles.count
    assert @pano_version.tiles.find_by(key: 'pano/' + @pano_version.id.to_s + '/dir/1.txt')
    assert @pano_version.tiles.find_by(key: 'pano/' + @pano_version.id.to_s + '/dir/2.txt')
    assert @pano_version.tiles.find_by(key: 'pano/' + @pano_version.id.to_s + '/dir/3.txt')
  end
end
