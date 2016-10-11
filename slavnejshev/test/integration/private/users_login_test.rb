require 'test_helper'

class Private::UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = private_users(:first)
  end
  
  test "fail to log in" do
    get private_login_path
    assert_template 'private/sessions/new'
    post private_login_path, params: { session: { name: "", password: "" } }
    assert_template 'private/sessions/new'
    assert_not flash.empty?
  end
  
  test "fail to log in with wrong password" do
    post private_login_path, params: { session: { name: @user.name, password: "wrongpassword" } }
    assert_template 'private/sessions/new'
    assert_not flash.empty?
  end
  
  test "successfull log in" do
    post private_login_path, params: { session: { name: @user.name, password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'private/users/show'
  end
end
