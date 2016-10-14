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
    name = @first.name
    email = @first.email
    patch private_user_path(@first), params: {
      private_user: { name: 'abc', email: 'abc@example.com' }}
    assert_not flash.empty?
    assert_redirected_to private_login_path
    @first.reload
    assert_equal name, @first.name
    assert_equal email, @first.email
  end
  
  test "need log in to access new user" do
    get new_private_user_path
    assert_not flash.empty?
    assert_redirected_to private_login_path
  end
  
  test "need log in to create user" do
    assert_no_difference 'Private::User.count' do
      post private_users_path params: {
        private_user: { name: 'abc', email: 'abc@example.com',
          password: 'password', password_confirmation: 'password' }}
    end
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
    name = @first.name
    email = @first.email
    patch private_user_path(@first), params: {
      private_user: { name: 'abc', email: 'abc@example.com' }}
    assert_not flash.empty?
    assert_redirected_to @second
    @first.reload
    assert_equal name, @first.name
    assert_equal email, @first.email
  end
  
  test "need access right to new user" do
    log_in_as(@second)
    get new_private_user_path
    assert_not flash.empty?
    assert_redirected_to @second
  end
  
  test "need access right to create user" do
    log_in_as(@second)
    assert_no_difference 'Private::User.count' do
      post private_users_path params: {
        private_user: { name: 'abc', email: 'abc@example.com',
          password: 'password', password_confirmation: 'password' }}
    end
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
  
  test "admin has access to new user" do
    log_in_as(@admin)
    get new_private_user_path
    assert_template 'private/users/new'
  end
  
  test "admin can create user" do
    log_in_as(@admin)
    post private_users_path params: {
      private_user: { name: 'abc', email: 'abc@example.com',
        password: 'password', password_confirmation: 'password' }}
    assert_redirected_to private_users_path
    follow_redirect!
    assert_not flash.empty?
    assert_match 'abc', response.body
  end
end

