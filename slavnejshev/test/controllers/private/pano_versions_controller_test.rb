require 'test_helper'

class Private::PanoVersionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @pano = private_panoramas(:private_pano)
    @pub_pano = private_panoramas(:public_pano)
    @pano_version = private_pano_versions(:first_pub_pano_version)
  end
  
  test 'need log in to add pano version to public panorama' do
    assert_no_difference 'Private::PanoVersion.count' do
      post private_panorama_pano_versions_path(@pub_pano.id)
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need access right to add pano version to public panorama' do
    log_in_as(@second)
    assert_no_difference 'Private::PanoVersion.count' do
      post private_panorama_pano_versions_path(@pub_pano.id)
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'need log in to add pano version' do
    assert_no_difference 'Private::PanoVersion.count' do
      post private_panorama_pano_versions_path(@pano.id)
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need access right to add pano version' do
    log_in_as(@second)
    assert_no_difference 'Private::PanoVersion.count' do
      post private_panorama_pano_versions_path(@pano.id)
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'owner can add pano version' do
    log_in_as(@first)
    next_index = 3
    assert_difference 'Private::PanoVersion.count', 1 do
      post private_panorama_pano_versions_path(@pano.id)
    end
    new_version = @pano.versions.find_by(idx: next_index)
    assert new_version
    assert_redirected_to private_show_pano_version_path(@pano, new_version.idx)
  end
  
  test 'admin can add pano version' do
    log_in_as(@admin)
    assert_difference 'Private::PanoVersion.count', 1 do
      post private_panorama_pano_versions_path(@pano.id)
    end
  end
  
  test 'can add pano version only to existing panorama' do
    log_in_as(@admin)
    assert_no_difference 'Private::PanoVersion.count' do
      post private_panorama_pano_versions_path(100)
    end
  end
  
  test 'need log in to patch pano version' do
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_no_difference 'Private::Datum.count' do
      patch private_pano_version_path(@pano_version), params: { private_pano_version: { config: config } }
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
    @pano_version.reload
    assert @pano_version.config.nil?
  end
  
  test 'need access right to patch pano version' do
    log_in_as(@second)
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_no_difference 'Private::Datum.count' do
      patch private_pano_version_path(@pano_version), params: { private_pano_version: { config: config } }
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
    @pano_version.reload
    assert @pano_version.config.nil?
  end
  
  test 'owner can patch pano version' do
    log_in_as(@first)
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_difference 'Private::Datum.count', 1 do
      patch private_pano_version_path(@pano_version), params: { private_pano_version: { config: config } }
    end
    assert_redirected_to private_show_pano_version_path(@pano_version.panorama, @pano_version.idx)
    @pano_version.reload
    assert_not @pano_version.config.nil?
  end
  
  test 'admin can patch pano version' do
    log_in_as(@admin)
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_difference 'Private::Datum.count', 1 do
      patch private_pano_version_path(@pano_version), params: { private_pano_version: { config: config } }
    end
    assert_redirected_to private_show_pano_version_path(@pano_version.panorama, @pano_version.idx)
    @pano_version.reload
    assert_not @pano_version.config.nil?
  end
end
