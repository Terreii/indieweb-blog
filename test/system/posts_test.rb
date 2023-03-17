require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:first_post)
    @entry = @post.entry
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "📨 Latest Posts"
    assert_css ".h-feed .h-entry", count: 3
  end

  test "visiting the index logged in" do
    login

    visit posts_url
    assert_selector "h1", text: "📨 Latest Posts"
    assert_selector "h2", text: "📝 Drafts"
    assert_selector "h2", text: "📤 Published"
  end

  test "visiting a Post" do
    visit post_url @post
    assert_selector "h1.p-name", text: @entry.title
    assert_selector "time.dt-published", text: @entry.published_at.to_date.to_s
    assert_selector ".p-author.h-card", text: I18n.translate("general.author-full")
    assert_selector ".h-entry"
    assert_selector ".e-content"
    assert_equal find(".trix-content").native.attribute('outerHTML').strip, @post.body.to_s.strip
  end

  test "Post should set Open Graph meta tags" do
    visit post_url @post

    assert_css "meta[property=\"og:title\"][content*=\"#{@entry.title}\"]", visible: false
    assert_css "meta[property=\"og:type\"][content*=article]", visible: false
    assert_css "meta[property=\"og:description\"][content*=\"#{@post.summary}\"]", visible: false
    assert_css "meta[property=\"og:image\"][content*=\"#{url_for @post.thumbnail}\"]", visible: false
    assert_css "meta[property=\"og:url\"][content*=\"#{post_url @post}\"]", visible: false
    assert_css "meta[name=\"twitter:card\"][content*=\"summary_large_image\"]", visible: false
  end

  test "creating a Post" do
    login

    visit posts_url
    click_on "Create new Post"

    fill_in "Title", with: Faker::Games::DnD.alignment
    fill_in_rich_text_area "Body", with: Faker::Lorem.paragraphs.join("\n")
    check "Published"

    fill_in "Create new tag", with: "dnd"
    click_on "Create Tag"
    assert_text "dnd"
    check "dnd"

    check tags(:bands).name

    click_on "Create Entry"

    assert_text "Post was successfully created"
    assert_link tags(:bands).name
    assert_link "dnd"
    click_on "Christophers thoughts"
  end

  test "creating a Post with thumbnail" do
    login

    visit posts_url
    click_on "Create new Post"

    fill_in "Title", with: Faker::Games::DnD.alignment
    fill_in_rich_text_area "Body", with: Faker::Lorem.paragraphs.join("\n")
    attach_file "Thumbnail", file_fixture("sample.jpg")
    check "Published"

    check tags(:bands).name

    click_on "Create Entry"

    assert_text "Post was successfully created"
    assert_css "img#thumbnail"
    click_on "Christophers thoughts"
  end

  test "creating a draft Post" do
    login

    visit posts_url
    click_on "Create new Post"
    title = Faker::Games::DnD.alignment

    fill_in "Title", with: title
    fill_in_rich_text_area "Body", with: Faker::Lorem.paragraphs
    click_on "Create Entry"

    assert_text "Post was successfully created"

    click_on "Logout"
    assert_no_text title
  end

  test "creating a Post without a title" do
    login

    visit new_post_url

    fill_in_rich_text_area "Body", with: Faker::Lorem.paragraphs
    click_on "Create Entry"

    assert_text "Entryable slug can't be blank"
    assert_text "Title can't be blank"
    click_on "Christophers thoughts"
  end

  test "updating a Post" do
    login

    visit posts_url
    click_on @entry.title
    click_on "Edit"

    fill_in "Title", with: @entry.title

    fill_in "Create new tag", with: "music"
    click_on "Create Tag"
    assert_text "music"
    check "music"

    check tags(:bands).name
    fill_in_rich_text_area "Body", with: Faker::Lorem.paragraphs

    click_on "Update Entry"

    assert_text "Post was successfully updated"
    assert_link tags(:bands).name
    assert_link "music"
    click_on "Christophers thoughts"
  end

  test "destroying a Post" do
    login

    visit posts_url
    click_on @entry.title
    click_on "Edit"

    sleep 0.1
    page.accept_confirm do
      click_on "Destroy this post", match: :first
    end
    sleep 0.1

    assert_text "Post was successfully destroyed"
  end
end
