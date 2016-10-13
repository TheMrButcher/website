require 'test_helper'

class Private::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = private_users(:admin)
    @first = private_users(:first)
    @second = private_users(:second)
  end
  
  test "need log in to see user" do
    get private_user_path(@first)
    assert_not flash.empty?
    assert_redirected_to private_login_path
  end
  
  test "need log in to see users index" do
    get private_users_path
    assert_not flash.empty?
    assert_redirected_to private_login_path
  end
  
  test "need log in to edit user" do
    get edit_private_user_path(@first)
    assert_not flash.empty?
    assert_redirected_to private_login_path
  end
  
  test "need log in to patch user" do
    patch private_user_path(@first), params: {
      user: { name: @first.name, email: @first.email }}
    assert_not flash.empty?
    assert_redirected_to private_login_path
  end
  
  test "need access right to see user" do
    log_in_as(@second)
    get private_user_path(@first)
    assert_not flash.empty?
    assert_redirected_to @second
  end
  
  test "need access right to see users index" do
    log_in_as(@second)
    get private_users_path
    assert_not flash.empty?
    assert_redirected_to @second
  end
  
  test "need access right to edit user" do
    log_in_as(@second)
    get edit_private_user_path(@first)
    assert_not flash.empty?
    assert_redirected_to @second
  end
  
  test "need access right to patch user" do
    log_in_as(@second)
    patch private_user_path(@first), params: {
      user: { name: @first.name, email: @first.email }}
    assert_not flash.empty?
    assert_redirected_to @second
  end
  
  test "admin can see any user" do
    log_in_as(@admin)
    get private_user_path(@first)
    assert_match @first.name, response.body
    assert_match @first.email, response.body
  end
  
  test "admin can see users index" do
    log_in_as(@admin)
    get private_users_path
    assert_template 'private/users/index'
  end
end
