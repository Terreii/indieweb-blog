require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "set_title should return the passed title" do
    alignment = Faker::Games::DnD.alignment
    assert_dom_equal alignment, set_title(alignment)
  end

  test "set_title should set the content for :title" do
    alignment = Faker::Games::DnD.alignment
    set_title(alignment)
    assert_dom_equal "#{alignment} | #{t('general.title')}", content_for(:title)
  end

  test "set_meta_data should render the meta data" do
    post = posts :first_post
    picture = post.thumbnail
    set_meta_data(description: "Test page", thumbnail: picture, url: url_for(post))

    assert_equal "Test page", content_for(:description)
    assert_equal full_url_for(picture), content_for(:thumbnail)
    assert_equal url_for(post), content_for(:share_url)
  end

  test "set_meta_data should use the request url if url is nil" do
    post = posts :first_post
    set_meta_data description: "Test page", thumbnail: post.thumbnail, url: nil

    assert_equal "http://test.host", content_for(:share_url)
  end

  test "set_meta_data should use a default thumbnail if it is nil" do
    post = posts :first_post
    set_meta_data description: "Test page", thumbnail: nil, url: url_for(post)

    assert_equal gravatar_url, content_for(:thumbnail)
  end

  test "gravatar_url should return the gravatar" do
    assert_match Rails.application.credentials.gravatar, gravatar_url
  end

  test "gravatar_url should take a optionnal size" do
    assert_match /\?s=200\z/, gravatar_url(200)
  end
end
