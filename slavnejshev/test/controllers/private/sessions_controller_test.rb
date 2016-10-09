require 'test_helper'

class Private::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get private_login_url
    assert_response :success
  end

end
