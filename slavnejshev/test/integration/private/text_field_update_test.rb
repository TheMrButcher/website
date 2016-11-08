require 'test_helper'

class Private::TextFieldUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @first = private_users(:first)
    @second = private_users(:second)
    @folder = private_folders(:pano_root)
    @pano = private_panoramas(:public_pano)
    @version = private_pano_versions(:first_pub_pano_version)
  end
  
  test 'need log in to update title of folder' do
    patch private_folder_path(@folder.id), params: { private_folder: { title: "Title" } }
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need right to update title of folder' do
    log_in_as(@second)
    patch private_folder_path(@folder.id), params: { private_folder: { title: "Title" } }
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'update title of folder' do
    log_in_as(@first)
    assert @folder.title.nil?
    new_title = "Title"
    patch private_folder_path(@folder.id), params: { private_folder: { title: new_title } }
    assert_redirected_to private_files_path(@folder)
    @folder.reload
    assert_equal new_title, @folder.readable_name
  end
  
  test 'need log in to update title of panorama' do
    patch private_panorama_path(@pano.id), params: { private_panorama: { title: "Title" } }
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need right to update title of panorama' do
    log_in_as(@second)
    patch private_panorama_path(@pano.id), params: { private_panorama: { title: "Title" } }
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'update title of panorama' do
    log_in_as(@first)
    assert @pano.title.nil?
    new_title = "Title"
    patch private_panorama_path(@pano.id), params: { private_panorama: { title: new_title } }
    assert_redirected_to private_show_pano_path(@pano)
    @pano.reload
    assert_equal new_title, @pano.readable_name
  end
  
  test 'update description of panorama' do
    log_in_as(@first)
    assert @pano.description.present?
    new_desc = "New description"
    patch private_panorama_path(@pano.id), params: { private_panorama: { description: new_desc } }
    assert_redirected_to private_show_pano_path(@pano)
    @pano.reload
    assert_equal new_desc, @pano.description
  end
  
  test 'need log in to update description of version' do
    patch private_pano_version_path(@version), params: { private_pano_version: { description: "New description" } }
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need right to update description of version' do
    log_in_as(@second)
    patch private_pano_version_path(@version), params: { private_pano_version: { description: "New description" } }
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'update description of version' do
    log_in_as(@first)
    assert @version.description.present?
    new_desc = "New description"
    patch private_pano_version_path(@version), params: { private_pano_version: { description: "New description" } }
    assert_redirected_to private_show_pano_version_path(@pano, @version.idx)
    @version.reload
    assert_equal new_desc, @version.description
  end
end
