module ApplicationHelper
  def set_title(title)
    content_for(:title, [title, t('general.title')].join(" | "))
    title
  end
end
