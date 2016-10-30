require 'test_helper'

class Private::DatumTest < ActiveSupport::TestCase
  def setup
    @datum = private_data(:first_pano_config_datum)
    @datum2 = private_data(:second_pano_config_datum)
  end
  
  test 'datum is valid' do
    assert @datum.valid?
    assert @datum2.valid?
  end
  
  test 'blank hash' do
    @datum.datum_hash = ' ' * 3
    assert_not @datum.valid?
  end
  
  test 'hash should be unique' do
    @datum.datum_hash = @datum2.datum_hash
    assert_not @datum.valid?
  end
  
  test 'blank path' do
    @datum.path = ' ' * 3
    assert_not @datum.valid?
  end
  
  test 'path should be unique' do
    @datum.path = @datum2.path
    assert_not @datum.valid?
  end
end
