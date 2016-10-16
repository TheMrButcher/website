require 'test_helper'

class Private::FoldersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @first_root = private_folders(:first_root)
    @first_child = private_folders(:first_child)
    @first_grandchild = private_folders(:first_grandchild)
    @second_root = private_folders(:second_root)
  end
  
  test 'need log in to see roots' do
    get private_roots_path
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need log in to see files' do
    get private_files_path(@first_root)
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need log in to see new root' do
    get private_roots_new_path
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need log in to add subfolder' do
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'child2', owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need log in to add root' do
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'new_root', owner: @first.name } }      
    end
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need access right to see roots' do
    log_in_as(@first)
    get private_roots_path
    assert_redirected_to private_user_path(@first)
    assert_not flash.empty?
  end
  
  test 'need access right to see new root' do
    log_in_as(@first)
    get private_roots_new_path
    assert_redirected_to private_user_path(@first)
    assert_not flash.empty?
  end
  
  test 'need access right to add root' do
    log_in_as(@first)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'new_root', owner: @first.name } }      
    end
    assert_redirected_to private_user_path(@first)
    assert_not flash.empty?
  end
  
  test 'owner can see files' do
    log_in_as(@first)
    get private_files_path(@first_root)
    assert_template 'private/folders/show'
    assert_match @first_root.name, response.body
    assert_match @first_child.name, response.body
  end
  
  test 'owner can add subfolder' do
    log_in_as(@first)
    name = 'child2'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_files_path(@first_root)
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'other user can not see files' do
    log_in_as(@second)
    get private_files_path(@first_root)
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'other user can not add subfolder' do
    log_in_as(@second)
    name = 'child2'
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
  
  test 'admin can see roots' do
    log_in_as(@admin)
    get private_roots_path
    assert_template 'private/folders/index'
    assert_match @first_root.name, response.body
    assert_match @second_root.name, response.body
  end
  
  test 'admin can see files' do
    log_in_as(@admin)
    get private_files_path(@first_root)
    assert_template 'private/folders/show'
    assert_match @first_root.name, response.body
    assert_match @first_child.name, response.body
  end
  
  test 'admin can see new root' do
    log_in_as(@admin)
    get private_roots_new_path
    assert_template 'private/folders/new'
  end
  
  test 'admin can add subfolder' do
    log_in_as(@admin)
    name = 'child2'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_files_path(@first_root)
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'admin can add root' do
    log_in_as(@admin)
    name = "new_root"
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name } }      
    end
    assert_redirected_to private_roots_path
    follow_redirect!
    assert_match name, response.body
  end
end
