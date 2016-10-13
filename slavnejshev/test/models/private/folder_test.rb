require 'test_helper'

class Private::FolderTest < ActiveSupport::TestCase
  def setup
    @first = private_users(:first)
    @root = Private::Folder.new(name: "root", owner_id: @first.id)
    @child = @root.children.new(name: "child", owner_id: @first.id)
  end
  
  test "root is valid" do
    assert @root.valid?
    assert "/root", @root.full_path
  end
  
  test "child is valid" do
    assert @child.valid?
    assert "/root/child", @child.full_path
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
end
