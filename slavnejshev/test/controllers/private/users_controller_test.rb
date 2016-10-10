require 'test_helper'

class Private::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get private_users_show_url
    assert_response :success
  end

  test "should get index" do
    get private_users_index_url
    assert_response :success
  end

  test "should get edit" do
    get private_users_edit_url
    assert_response :success
  end

end
