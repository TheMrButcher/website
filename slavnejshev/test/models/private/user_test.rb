require 'test_helper'

class Private::UserTest < ActiveSupport::TestCase
  def setup
    @user = Private::User.new(name: "Example", email: "example@mail.ru",
                password: "password", password_confirmation: "password")
  end
  
  test "valid user" do
    assert @user.valid?
  end
  
  test "empty name" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "blank name" do
    @user.name = " " * 3
    assert_not @user.valid?
  end
  
  test "too long name" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end
  
  test "blank email" do
    @user.email = " " * 5 
    assert_not @user.valid?
  end
  
  test "too long email" do
    @user.email = "a" * 248 + "@mail.ru"
    assert_not @user.valid?
  end
  
  test "invalid email" do
    invalid_emails = %w[usermailru user@mailru usermail.ru user.mail.ru]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid"
    end
  end
  
  test "blank password" do
    @user.password = @user.password_confirmation = " " * 10
    assert_not @user.valid?
  end
  
  test "too small password" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end
  
  test "too long password" do
    @user.password = @user.password_confirmation = "a" * 31
    assert_not @user.valid?
  end
  
  test "name is unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end
