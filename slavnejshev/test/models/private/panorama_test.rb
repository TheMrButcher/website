require 'test_helper'

class Private::PanoramaTest < ActiveSupport::TestCase
  def setup
    @first = private_users(:first)
    @pano_folder = Private::Folder.new(name: "folder", owner_id: @first.id, stores_panoramas: true)
    @pano_folder.save
    @panorama = @pano_folder.panoramas.build(name: "panorama")
  end
  
  test "panorama is created" do
    assert_not @panorama.nil?
  end
  
  test "panorama has folder" do
    assert_equal @pano_folder.id, @panorama.folder_id
  end
  
  test "panorama is valid" do
    assert @panorama.valid?
  end
  
  test "valid panorama can be saved" do
    assert @panorama.save
    assert_equal "folder/panorama", @panorama.full_path
    assert_equal @pano_folder.owner, @panorama.owner
    assert_equal 1, @pano_folder.panoramas.count
  end
  
  test "blank name" do
    @panorama.name = " " * 3
    assert_not @panorama.valid?
  end
  
  test "too long name" do
    @panorama.name = "a" * 51
    assert_not @panorama.valid?
  end
  
  test "nil title" do
    @panorama.title = nil
    assert @panorama.valid?
  end
  
  test "blank title" do
    @panorama.title = " " * 3
    assert @panorama.valid?
  end
  
  test "too long title" do
    @panorama.title = "a" * 51
    assert_not @panorama.valid?
  end
  
  test "readable name" do
    assert @panorama.title.nil?
    assert @panorama.name.present?
    assert_equal @panorama.name, @panorama.readable_name
    new_title = "Title"
    @panorama.title = new_title
    assert_equal new_title, @panorama.readable_name
  end
  
  test "require folder" do
    @panorama.folder_id = nil
    assert_not @panorama.valid?
  end
  
  test "panorama with blank text is valid" do
    @panorama.description = " " * 3
    assert @panorama.valid?
  end
  
  test "panorama with long text is valid" do
    @panorama.description = "a" * 500
    assert @panorama.valid?
  end
  
  test "too long text" do
    @panorama.description = "a" * 1001
    assert_not @panorama.valid?
  end
  
  test "name can repeat" do
    folder2 = Private::Folder.new(name: "folder2", owner_id: @first.id, stores_panoramas: true)
    assert folder2.save
    pano_with_same_name = folder2.panoramas.build(name: @panorama.name)
    assert @panorama.save
    assert pano_with_same_name.save
  end
  
  test "full_path is unique" do
    pano_with_same_path = Private::Panorama.new(name: @panorama.name, folder_id: @pano_folder.id)
    assert @panorama.save
    assert_equal "folder/panorama", @panorama.full_path
    pano_with_same_path.update_paths
    assert_equal "folder/panorama", pano_with_same_path.full_path
    assert_not pano_with_same_path.save
  end
end
