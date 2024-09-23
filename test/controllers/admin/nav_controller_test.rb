require "test_helper"

class Admin::NavControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_nav_url
    assert_response :success
    assert_select "turbo-frame#admin_nav span.nav__item", count: 10
  end

  test "should get index when logged in" do
    login
    get admin_nav_url
    assert_response :success
    assert_select "turbo-frame#admin_nav span.nav__item", count: 14
  end
end
