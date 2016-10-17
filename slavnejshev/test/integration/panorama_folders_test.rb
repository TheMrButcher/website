require 'test_helper'

class PanoramaFoldersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @pano_root = private_folders(:pano_root)
  end
  
  test 'owner can add panorama subfolder' do
    log_in_as(@first)
    name = 'pano_child'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @pano_root.id, stores_panoramas: '1' } }      
    end
    assert_redirected_to private_files_path(@pano_root)
    follow_redirect!
    assert_match name, response.body
    pano_child = Private::Folder.find_by(full_path: @pano_root.name + '/' + name)
    assert pano_child
    assert pano_child.stores_panoramas?
  end
  
  test 'admin can add panorama roots' do
    log_in_as(@admin)
    name = 'new_pano_root'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, stores_panoramas: '1' } }      
    end
    assert_redirected_to private_roots_path
    follow_redirect!
    assert_match name, response.body
    new_pano_root = Private::Folder.find_by(full_path: name)
    assert new_pano_root
    assert new_pano_root.stores_panoramas?
  end
end
