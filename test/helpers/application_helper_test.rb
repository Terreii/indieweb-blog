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
end
