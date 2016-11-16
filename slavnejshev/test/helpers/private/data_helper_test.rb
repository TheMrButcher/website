require 'test_helper'

class Private::DataHelperTest < ActionView::TestCase
  def setup
    @first = private_users(:first)
    @pano_folder = Private::Folder.create!(name: "folder", owner_id: @first.id, stores_panoramas: true)
    @panorama = @pano_folder.panoramas.create(name: "panorama")
    @ver1 = @panorama.versions.create(idx: 1)
    @ver2 = @panorama.versions.create(idx: 2)
    @old_prefix = make_prefix(@ver1)
    @new_prefix = make_prefix(@ver2)
    @datum = Private::Datum.create!(path: "hij", datum_hash: "hij")
    @datum.files.create(
      original_name: "hij1", key: @old_prefix + "hij1", storage: @ver1, file_type: :pano_tile)
    @datum.files.create(
      original_name: "hij2", key: @old_prefix + "hij2", storage: @ver1, file_type: :pano_tile)
    @datum.files.create(
      original_name: "hij3", key: @old_prefix + "hij3", storage: @ver1, file_type: :pano_tile)
    @datum.files.create(
      original_name: "hij4", key: @old_prefix + "hij4", storage: @ver1, file_type: :pano_hotspot_image)
    @datum.files.create(
      original_name: "hij5", key: @old_prefix + "hij5", storage: @ver1, file_type: :pano_hotspot_image)
  end
  
  test "copy tiles" do
    assert_equal 3, @ver1.tiles.count
    assert_equal "pano/" + @ver1.id.to_s + "/", @old_prefix
    assert_equal "pano/" + @ver2.id.to_s + "/", @new_prefix
    @ver1.tiles.each do |tile|
      assert_match "pano/" + @ver1.id.to_s + "/", tile.key
    end
    assert_difference "Private::File.count", 3 do
      copy_files(@ver1, @ver2, :pano_tile)
    end
    @ver2.reload
    assert_equal 3, @ver2.tiles.count
    @ver2.tiles.each do |tile|
      assert_no_match @old_prefix, tile.key
      assert_match @new_prefix, tile.key
      assert_match "hij", tile.key
    end
      
    assert @ver2.config.nil?
    assert_equal 0, @ver2.hotspots.count
  end
  
  test "copy hotspots" do
    assert_equal 2, @ver1.hotspots.count
    assert_equal "pano/" + @ver1.id.to_s + "/", @old_prefix
    assert_equal "pano/" + @ver2.id.to_s + "/", @new_prefix
    @ver1.hotspots.each do |hotspot|
      assert_match "pano/" + @ver1.id.to_s + "/", hotspot.key
    end
    assert_difference "Private::File.count", 2 do
      copy_files(@ver1, @ver2, :pano_hotspot_image)
    end
    @ver2.reload
    assert_equal 2, @ver2.hotspots.count
    @ver2.hotspots.each do |hotspot|
      assert_no_match @old_prefix, hotspot.key
      assert_match @new_prefix, hotspot.key
      assert_match "hij", hotspot.key
    end
      
    assert @ver2.config.nil?
    assert_equal 0, @ver2.tiles.count
  end
end
