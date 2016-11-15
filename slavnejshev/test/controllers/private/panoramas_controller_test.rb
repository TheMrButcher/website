require 'test_helper'

class Private::PanoramasControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @pano_folder = private_folders(:pano_root)
    @not_pano_folder = private_folders(:first_root)
    @pano = private_panoramas(:private_pano)
  end
  
  test 'need log in to see pano' do
    get private_show_pano_path(@pano)
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need log in to add pano' do
    assert_no_difference 'Private::Panorama.count' do
      post private_panoramas_path params: {
        private_panorama: { name: 'new_pano', folder_id: @pano_folder.id } }      
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need access right to see pano' do
    log_in_as(@second)
    get private_show_pano_path(@pano)
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'need access right to add pano' do
    log_in_as(@second)
    assert_no_difference 'Private::Panorama.count' do
      post private_panoramas_path params: {
        private_panorama: { name: 'new_pano', folder_id: @pano_folder.id } }      
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end

  test 'owner can see pano' do
    log_in_as(@first)
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'owner can add pano' do
    log_in_as(@first)
    name = 'new_pano'
    assert_difference 'Private::Panorama.count', 1 do
      post private_panoramas_path params: {
        private_panorama: { name: name, folder_id: @pano_folder.id } }      
    end
    new_pano = @pano_folder.panoramas.find_by(name: name)
    assert new_pano
    assert_equal 'pano_root/new_pano', new_pano.full_path
    assert_redirected_to private_show_pano_path(new_pano)
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'admin can see pano' do
    log_in_as(@admin)
    get private_show_pano_path(@pano)
    assert_template 'private/panoramas/show'
    assert_match @pano.name, response.body
  end
  
  test 'admin can add pano' do
    log_in_as(@admin)
    name = 'new_pano'
    assert_difference 'Private::Panorama.count', 1 do
      post private_panoramas_path params: {
        private_panorama: { name: name, folder_id: @pano_folder.id } }      
    end
    new_pano = @pano_folder.panoramas.find_by(name: name)
    assert new_pano
    assert_redirected_to private_show_pano_path(new_pano)
  end
  
  test 'folder should have right to store panoramas' do
    log_in_as(@admin)
    assert_no_difference 'Private::Panorama.count' do
      post private_panoramas_path params: {
        private_panorama: { name: 'new_pano', folder_id: @not_pano_folder.id } }      
    end
    assert_redirected_to private_files_path(@not_pano_folder)
    assert_not flash.empty?
  end
  
  test 'need log in to delete panorama' do
    assert_no_difference 'Private::Panorama.count' do
      delete private_panorama_path(@pano.id)
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need right to delete panorama' do
    log_in_as(@second)
    assert_no_difference 'Private::Panorama.count' do
      delete private_panorama_path(@pano.id)
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'delete panorama' do
    log_in_as(@first)
    assert_difference 'Private::Panorama.count', -1 do
      delete private_panorama_path(@pano.id)
    end
    assert_redirected_to private_files_path(@pano_folder)
  end
end

