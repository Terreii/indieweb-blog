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
    fill_in "Title", with: Faker::Games::DnD.alignment

    find("details").click
    check tags(:bands).name
    fill_in "New tags", with: "dnd,games"

    click_on "Create Post"

    assert_text "Post was successfully created"
    assert_link tags(:bands).name
    assert_link "dnd"
    assert_link "games"
    click_on "Christophers thoughts"
  end

  test "updating a Post" do
    sign_in

    visit posts_url
    click_on @post.title
    click_on "Edit"

    fill_in "Title", with: @post.title

    find("details").click
    check tags(:bands).name
    fill_in "New tags", with: "me,personal"

    click_on "Update Post"

    assert_text "Post was successfully updated"
    assert_link tags(:bands).name
    assert_link "me"
    assert_link "personal"
    click_on "Christophers thoughts"
  end

  test "destroying a Post" do
    sign_in

    visit posts_url
    click_on @post.title
    click_on "Edit"

    sleep 0.1
    page.accept_confirm do
      click_on "Destroy", match: :first
    end
    sleep 0.1

    assert_text "Post was successfully destroyed"
  end
end
