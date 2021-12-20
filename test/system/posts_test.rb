require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:first_post)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h2:last-of-type", text: "📨 Latest Posts"
  end

  test "creating a Post" do
    sign_in

    visit posts_url
    click_on "Create new Post"

    fill_in "Published at", with: @post.published_at
    fill_in "Title", with: @post.title
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Christophers thoughts"
  end

  test "updating a Post" do
    sign_in

    visit posts_url
    click_on @post.title
    click_on "Edit"

    fill_in "Title", with: @post.title
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Christophers thoughts"
  end

  test "destroying a Post" do
    sign_in

    visit posts_url
    click_on @post.title
    click_on "Edit"

    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post was successfully destroyed"
  end
end
