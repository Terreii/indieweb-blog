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
        assert_select "a[title=\"#{I18n.t("admin.table.edit")}\"] svg"
        assert_select "button[title=\"#{I18n.t("admin.table.delete")}\"] svg"
      end
    end
  end

  test "index should filter types" do
    login
    get admin_path(types: [Entry.types.first])

    Entry.where(entryable_type: Entry.types.first).limit(10).order(published_at: "DESC").each do |entry|
      assert_select "#" + dom_id(entry)
    end

    Entry.where.not(entryable_type: Entry.types.first).limit(10).order(published_at: "DESC").each do |entry|
      assert_select "#" + dom_id(entry), false
    end
  end

  test "index should filter published" do
    login
    get admin_path(published: "draft")

    Entry.draft.limit(10).order(published_at: "DESC").each do |entry|
      assert_select "#" + dom_id(entry)
    end

    Entry.published.limit(10).order(published_at: "DESC").each do |entry|
      assert_select "#" + dom_id(entry), false
    end
  end

  test "index should filter multiple options" do
    login
    get admin_path(published: "draft", types: [Post.name])

    Entry.draft.posts.each do |entry|
      assert_select "#" + dom_id(entry)
    end

    Entry.published.limit(10).order(published_at: "DESC").each do |entry|
      assert_select "#" + dom_id(entry), false
    end
  end

  test "should redirect search to filtered index route" do
    login
    post admin_search_path, params: { published: "draft", types: [Entry.types.first] }
    assert_redirected_to admin_path(published: "draft", types: [Entry.types.first])
  end

  test "search should remove filters that select all" do
    login
    post admin_search_path, params: { published: "on", types: Entry.types }
    assert_redirected_to admin_path
  end

  test "search should remove invalid search_params" do
    login
    post admin_search_path, params: {
      published: Faker::Games::DnD.alignment,
      types: [
        Entry.types.first,
        Faker::Games::DnD.klass
      ]
    }
    assert_redirected_to admin_path(types: [Entry.types.first])
  end

  test "search should require login" do
    post admin_search_path, params: { published: "draft" }
    assert_redirected_to login_path
  end
end
