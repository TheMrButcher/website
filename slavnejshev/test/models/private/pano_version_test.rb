require 'test_helper'

class Private::PanoVersionTest < ActiveSupport::TestCase
  def setup
    @pano = private_panoramas(:private_pano)
    @pano_v1 = private_pano_versions(:first_pano_version)
    @pano_v2 = private_pano_versions(:second_pano_version)
    @other_pano = private_panoramas(:public_pano)
    @config = private_files(:first_pano_config)
  end
  
  test "panorama versions are valid" do
    assert @pano_v1.valid?
    assert @pano_v2.valid?
  end
  
  test "panorama and versions are connected" do
    assert_equal 2, @pano.versions.count
    assert_includes @pano.versions, @pano_v1
    assert_includes @pano.versions, @pano_v2
    assert_equal @pano, @pano_v1.panorama
    assert_equal @pano, @pano_v2.panorama
    assert_equal @config, @pano_v1.config
  end
  
  test "empty version text is valid" do
    @pano_v1.description = ''
    assert @pano_v1.valid?
  end
  
  test "long version text is valid" do
    @pano_v1.description = 'a' * 500
    assert @pano_v1.valid?
  end
  
  test "too long version text is invalid" do
    @pano_v1.description = 'a' * 1001
    assert_not @pano_v1.valid?
  end
  
  test "version index is present" do
    @pano_v2.idx = nil
    assert_not @pano_v2.valid?
  end
  
  test "version index is positive" do
    @pano_v2.idx = -1
    assert_not @pano_v2.valid?
  end
  
  test "version index is unique in pano" do
    @pano_v2.idx = @pano_v1.idx
    assert_not @pano_v2.valid?
  end
  
  test "version index can be equal to version index in other pano" do
    other_pano_version = @other_pano.versions.build(idx: @pano_v1.idx)
    assert other_pano_version.valid?
    assert other_pano_version.save
  end
end
