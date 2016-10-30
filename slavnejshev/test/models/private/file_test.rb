require 'test_helper'

class Private::FileTest < ActiveSupport::TestCase
  def setup
    @file = private_files(:first_pano_config)
    @file2 = private_files(:second_pano_config)
    @datum = private_data(:first_pano_config_datum)
    @datum2 = private_data(:second_pano_config_datum)
  end
  
  test 'file is valid' do
    assert @file.valid?
    assert @file2.valid?
    assert_equal @datum, @file.datum
    assert_equal @datum2, @file2.datum
  end
  
  test 'blank original name' do
    @file.original_name = ' ' * 3
    assert_not @file.valid?
  end
  
  test 'too long original name' do
    @file.original_name = 'a' * 257
    assert_not @file.valid?
  end
  
  test 'blank key' do
    @file.key = ' ' * 3
    assert_not @file.valid?
  end
  
  test 'too long key' do
    @file.key = 'a' * 1025
    assert_not @file.valid?
  end
  
  test 'key should be unique' do
    @file.key = @file2.key
    assert_not @file.valid?
  end
  
  test 'blank datum' do
    @file.datum_id = nil
    assert_not @file.valid?
  end
  
  test 'files can have same datum' do
    @file.datum_id = @file2.datum_id
    assert @file.valid?
  end
  
  test 'file should have type' do
    @file.file_type = nil
    assert_not @file.valid?
  end
  
  test 'file can have any valid type' do
    @file.ordinary!
    assert @file.valid?
    assert_equal @file.file_type, "ordinary"
    @file.pano_config!
    assert @file.valid?
    assert_equal @file.file_type, "pano_config"
  end
end
