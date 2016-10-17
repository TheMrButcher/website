require 'test_helper'

class Private::PublicFoldersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @first_root = private_folders(:first_root)
    @first_child = private_folders(:first_child)
    @first_public_child = private_folders(:first_public_child)
    @public_root = private_folders(:public_root)
    @public_child = private_folders(:public_child)
  end
  
  test 'no need to log in to see public folder' do
    get private_files_path(@public_root)
    assert_template 'private/folders/show'
    assert_match @public_child.name, response.body
  end
  
  test 'other user can see public folder' do
    log_in_as(@second)
    get private_files_path(@public_root)
    assert_template 'private/folders/show'
    assert_match @public_child.name, response.body
  end
  
  test 'admin can see public folder' do
    log_in_as(@admin)
    get private_files_path(@public_root)
    assert_template 'private/folders/show'
    assert_match @public_child.name, response.body
  end
  
  test 'need to log in to add subfolder to public folder' do
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'new_child', owner: @first.name, parent_id: @public_root.id } }      
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'other user can not add subfolder to public folder' do
    log_in_as(@second)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @public_root.id } }      
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'owner can add subfolder to public folder' do
    log_in_as(@first)
    name = 'child2'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @public_root.id, public: '1' } }      
    end
    assert_redirected_to private_files_path(@public_root)
    follow_redirect!
    assert_match name, response.body
    @first_root.reload
    public_child2 = @public_root.children.find_by(name: name)
    assert public_child2
    assert public_child2.public?
  end
  
  test 'admin can add subfolder to public folder' do
    log_in_as(@admin)
    name = 'child2'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @public_root.id } }      
    end
    assert_redirected_to private_files_path(@public_root)
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'admin can add public root' do
    log_in_as(@admin)
    name = "new_public_root"
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, public: '1' } }      
    end
    assert_redirected_to private_roots_path
    follow_redirect!
    assert_match name, response.body
    new_public_root = Private::Folder.find_by(full_path: name)
    assert new_public_root
    assert new_public_root.public?
  end
end
