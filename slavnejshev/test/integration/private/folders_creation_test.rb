require 'test_helper'

class Private::FoldersCreationTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
    @first_root = private_folders(:first_root)
  end
  
  test 'blank root name' do
    log_in_as(@admin)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: ' ' * 3, owner: @first.name } }      
    end
    assert_redirected_to private_roots_new_path
    assert_not flash.empty?
  end
  
  test 'too long root name' do
    log_in_as(@admin)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'a' * 51, owner: @first.name } }      
    end
    assert_redirected_to private_roots_new_path
    assert_not flash.empty?
  end
  
  test 'blank root owner' do
    log_in_as(@admin)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'new_root', owner: ' ' * 3 } }      
    end
    assert_redirected_to private_roots_new_path
    assert_not flash.empty?
  end
  
  test 'wrong root owner' do
    log_in_as(@admin)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'new_root', owner: 'abc' } }      
    end
    assert_redirected_to private_roots_new_path
    assert_not flash.empty?
  end
  
  test 'valid root creation' do
    log_in_as(@admin)
    name = 'new_root'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name } }      
    end
    assert_redirected_to private_roots_path
    follow_redirect!
    assert_match name, response.body
  end
  
  test 'blank subfolder name' do
    log_in_as(@first)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: ' ' * 3, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_files_path(@first_root)
    assert_not flash.empty?
  end
  
  test 'too long subfolder name' do
    log_in_as(@first)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'a' * 51, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_files_path(@first_root)
    assert_not flash.empty?
  end
  
  test 'subfolder has wrong owner' do
    log_in_as(@first)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'subfolder', owner: @second.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_user_path(@first)
    assert_not flash.empty?
  end
  
  test 'subfolder has wrong parent' do
    log_in_as(@first)
    assert_no_difference 'Private::Folder.count' do
      post private_folders_path params: {
        private_folder: { name: 'subfolder', owner: @first.name, parent_id: -123456 } }      
    end
    assert_redirected_to private_user_path(@first)
    assert_not flash.empty?
  end
  
  test 'valid subfolder creation' do
    log_in_as(@first)
    name = 'subfolder'
    assert_difference 'Private::Folder.count', 1 do
      post private_folders_path params: {
        private_folder: { name: name, owner: @first.name, parent_id: @first_root.id } }      
    end
    assert_redirected_to private_files_path(@first_root)
    follow_redirect!
    assert_match name, response.body
  end
end
