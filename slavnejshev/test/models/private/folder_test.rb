require 'test_helper'

class Private::FolderTest < ActiveSupport::TestCase
  def setup
    @first = private_users(:first)
    @root = Private::Folder.new(name: "root", owner_id: @first.id)
    @child = @root.children.new(name: "child", owner_id: @first.id)
  end
  
  test "root is valid" do
    assert @root.valid?
    assert @root.save
    assert_equal "root", @root.full_path
  end
  
  test "child is valid" do
    assert @root.save
    assert @child.valid?
    assert @child.save
    assert_equal "root/child", @child.full_path
  end
  
  test "require owner" do
    @root.owner_id = nil
    assert_not @root.valid?
  end
  
  test "blank name" do
    @root.name = " " * 3
    assert_not @root.valid?
  end
  
  test "too long name" do
    @root.name = "a" * 51
    assert_not @root.valid?
  end
  
  test "full_path of root is correct after save" do
    @root.save
    assert_equal "root", @root.full_path
  end
  
  test "full_path of child is correct after save" do
    @root.save
    @child.save
    assert_equal "root/child", @child.full_path
    assert_equal @root.children.count, 1
    assert_equal @root.id, @child.parent.id
  end
  
  test "name can repeat" do
    folder_with_same_name = Private::Folder.new(name: @child.name, owner_id: @first.id)
    assert @root.save
    assert @child.save
    assert folder_with_same_name.save
  end
  
  test "full_path is unique" do
    folder_with_same_path = @root.children.new(name: @child.name, owner_id: @first.id)
    assert @root.save
    assert @child.save
    assert_equal "root/child", @child.full_path
    folder_with_same_path.update_paths
    assert_equal "root/child", folder_with_same_path.full_path
    assert_not folder_with_same_path.save
  end
end
