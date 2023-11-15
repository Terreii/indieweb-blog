require "test_helper"

class Admin::OverviewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login
    get admin_path
    assert_response :success
  end

  test "should require a session" do
    get admin_path
    assert_redirected_to login_path
  end

  test "should have a create link for all entry types" do
    login
    get admin_path
    Entry.types.each do |type|
      path = Rails.application.routes.url_helpers.public_send "new_#{type.downcase}_path".to_sym
      assert_select "#admin_create__list a[href=\"#{path}\"]", type
    end
  end

  test "should list all entries" do
    login
    get admin_path
    Entry.limit(10).order(published_at: "DESC").each do |entry|
      assert_select "##{dom_id entry}" do
        assert_select "a", 2
        assert_select "a", entry.title
        assert_select "a", I18n.t("admin.edit")
        assert_select "button", I18n.t("admin.delete")
      end
    end
  end
end
