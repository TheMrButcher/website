require 'test_helper'

class Private::PanoVersionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @pano = private_panoramas(:private_pano)
    @pub_pano = private_panoramas(:public_pano)
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
end
