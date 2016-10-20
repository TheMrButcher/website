require 'test_helper'

class Private::PublicPanoramasTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @pano_folder = private_folders(:pano_pub_child)
    @pano = private_panoramas(:public_pano)
  end
  
  test 'no need to log in to see pano' do
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'need log in to add public pano' do
    assert_no_difference 'Private::Panorama.count' do
      post private_panoramas_path params: {
        private_panorama: { name: 'new_pano', folder_id: @pano_folder.id } }      
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'other user can see public pano' do
    log_in_as(@second)
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'need access right to add public pano' do
    log_in_as(@second)
    assert_no_difference 'Private::Panorama.count' do
      post private_panoramas_path params: {
        private_panorama: { name: 'new_pano', folder_id: @pano_folder.id } }      
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end

  test 'owner can see public pano' do
    log_in_as(@first)
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'owner can add public pano' do
    log_in_as(@first)
    name = 'new_pano'
    assert_difference 'Private::Panorama.count', 1 do
      post private_panoramas_path params: {
        private_panorama: { name: name, folder_id: @pano_folder.id } }      
    end
    new_pano = @pano_folder.panoramas.find_by(name: name)
    assert new_pano
    assert new_pano.public?
    assert_redirected_to private_show_pano_path(new_pano)
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'admin can see public pano' do
    log_in_as(@admin)
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'admin can add public pano' do
    log_in_as(@admin)
    name = 'new_pano'
    assert_difference 'Private::Panorama.count', 1 do
      post private_panoramas_path params: {
        private_panorama: { name: name, folder_id: @pano_folder.id } }      
    end
    new_pano = @pano_folder.panoramas.find_by(name: name)
    assert new_pano
    assert new_pano.public?
    assert_redirected_to private_show_pano_path(new_pano)
  end
end
