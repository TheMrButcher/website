require 'test_helper'

class Private::FoldersRelationsTest < ActionDispatch::IntegrationTest
  def setup
    @first = private_users(:first)
    @first_root = private_folders(:first_root)
    @first_child = private_folders(:first_child)
    @first_grandchild = private_folders(:first_grandchild)
  end
  
  test 'root view is correct' do
    log_in_as(@first)
    get private_files_path(@first_root)
    assert_template 'private/folders/show'
    assert_select 'a[href=?]', private_files_path(@first_child)
    assert_equal @first_root.children.count, 7
    @first_root.children.each do |child|
      assert_select 'a[href=?]', private_files_path(child)
    end
  end
  
  test 'subfolder view is correct' do
    log_in_as(@first)
    get private_files_path(@first_child)
    assert_template 'private/folders/show'
    assert_select 'a[href=?]', private_files_path(@first_root)
    assert_select 'a[href=?]', private_files_path(@first_grandchild)
  end
end
