require 'test_helper'

class Private::ConfigUploadingTest < ActionDispatch::IntegrationTest
  def setup
    @first = private_users(:first)
    @pano_v1 = private_pano_versions(:first_pub_pano_version)
    @pano_v2 = private_pano_versions(:second_pub_pano_version)
  end
  
  test 'successfull config loading' do
    log_in_as(@first)
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_difference 'Private::Datum.count', 1 do
      patch private_pano_version_path(@pano_v1), params: { private_pano_version: { config: config } }
    end
    assert_redirected_to private_show_pano_version_path(@pano_v1.panorama, @pano_v1.idx)
    @pano_v1.reload
    assert_not @pano_v1.config.nil?
    assert_equal 'pano.xml', @pano_v1.config.original_name
    assert_equal 'pano/' + @pano_v1.id.to_s + '/pano.xml', @pano_v1.config.key
    
    assert_not @pano_v1.config.datum.nil?
    datum = @pano_v1.config.datum
    assert datum.datum_hash.present?
    assert datum.path.present?
  end
  
  test 'duplicate config' do
    log_in_as(@first)
    config = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    assert_difference 'Private::Datum.count', 1 do
      patch private_pano_version_path(@pano_v1), params: { private_pano_version: { config: config } }
      patch private_pano_version_path(@pano_v2), params: { private_pano_version: { config: config } }
    end
    @pano_v1.reload
    @pano_v2.reload
    assert_not @pano_v1.config.nil?
    assert_not @pano_v2.config.nil?
    assert_equal 'pano.xml', @pano_v1.config.original_name
    assert_equal 'pano.xml', @pano_v2.config.original_name
    assert_not_equal @pano_v1.config.key, @pano_v2.config.key
    
    assert_not @pano_v1.config.datum.nil?
    assert_not @pano_v2.config.datum.nil?
    assert_equal @pano_v1.config.datum_id, @pano_v2.config.datum_id
  end
  
  test 'different configs' do
    log_in_as(@first)
    config1 = fixture_file_upload('test/fixtures/private/files/1/pano.xml', 'text/xml')
    config2 = fixture_file_upload('test/fixtures/private/files/2/pano.xml', 'text/xml')
    assert_difference 'Private::Datum.count', 2 do
      patch private_pano_version_path(@pano_v1), params: { private_pano_version: { config: config1 } }
      patch private_pano_version_path(@pano_v2), params: { private_pano_version: { config: config2 } }
    end
    @pano_v1.reload
    @pano_v2.reload
    assert_not @pano_v1.config.nil?
    assert_not @pano_v2.config.nil?
    assert_equal 'pano.xml', @pano_v1.config.original_name
    assert_equal 'pano.xml', @pano_v2.config.original_name
    assert_not_equal @pano_v1.config.key, @pano_v2.config.key
    
    assert_not @pano_v1.config.datum.nil?
    assert_not @pano_v2.config.datum.nil?
    assert_not_equal @pano_v1.config.datum_id, @pano_v2.config.datum_id
    assert_not_equal @pano_v1.config.datum.path, @pano_v2.config.datum.path 
    assert_not_equal @pano_v1.config.datum.datum_hash, @pano_v2.config.datum.datum_hash
  end
end
