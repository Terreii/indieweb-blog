# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "should create Tag" do
    tag = Tag.new
    tag.name = "tests"

    assert tag.save
  end

  test "should find tag" do
    tag_id = tags(:bands).id
    assert_nothing_raised { Tag.find tag_id }
  end

  test "should validate tag name" do
    tag = Tag.new
    tag.name = "Tests"

    assert_not tag.save
    assert_equal tag.errors.first.full_message, "Name can only include a-z, 0-9, - and _"
  end

  test "should not create a tag with a not unique name" do
    tag = Tag.new name: tags(:programming).name
    assert_raise(ActiveRecord::RecordNotUnique) { tag.save }
  end
end
