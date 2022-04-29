require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:first_post)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Hi, I'm Christopher Astfalk!"
    assert_selector "h2", text: "📨 Latest Posts"
  end

  test "visiting a Post" do
    visit post_url @post
    assert_selector "h1.p-name", text: @post.title
    assert_selector "time.dt-published", text: @post.published_at.to_date.to_s
    assert_selector ".p-author.h-card", text: I18n.translate("general.author-full")
    assert_selector ".h-entry"
    assert_selector ".e-content"
    assert_equal find(".trix-content").native.attribute('outerHTML').strip, @post.body.to_s.strip
  end

  test "creating a Post" do
    login

    visit posts_url
    click_on "Create new Post"

    fill_in "Title", with: Faker::Games::DnD.alignment
    check "Published"

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

  test "creating a Post without a title" do
    login

    visit new_post_url

    click_on "Create Post"

    assert_text "Slug can't be blank"
    assert_text "Title can't be blank"
    click_on "Christophers thoughts"
  end

  test "updating a Post" do
    login

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
    login

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
