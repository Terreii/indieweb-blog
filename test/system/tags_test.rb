require "application_system_test_case"

class TagsTest < ApplicationSystemTestCase
   test "visiting the index" do
     visit tags_url

     assert_selector "h1", text: "Tags"
   end

   test "visiting a tag" do
     visit root_url
     tag = entries(:first_post).tags.first
     first(:link, tag.name).click

     assert_selector "h1", text: tag.name
     assert_selector "h2", text: "Posts"
     assert_selector "h2", text: "Bookmarks"

     click_on "Back to all tags"
   end
end
