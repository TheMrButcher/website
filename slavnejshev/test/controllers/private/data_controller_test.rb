require 'test_helper'

class Private::DataControllerTest < ActionDispatch::IntegrationTest
  def setup
    @second = private_users(:second)
    @file = private_files(:first_pano_config)
  end
  
  test 'need log in to get private file' do
    get private_show_datum_path(@file)
    assert_redirected_to private_login_path
    assert_not flash.empty?
  end
  
  test 'need right to get private file' do
    log_in_as(@second)
    get private_show_datum_path(@file)
    assert_redirected_to private_user_path(@second)
    assert_not flash.empty?
  end
end
