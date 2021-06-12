require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:prashant)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{session:{email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
  end
  #
  # test "login with valid information" do
  #   get login_path
  #   post login_path, params:{session:{email: @user.email, password: "password"}}
  #   assert_redirected_to @user
  #   follow_redirect!
  #   assert_template 'users/show'
  # end
end
