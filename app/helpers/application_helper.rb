module ApplicationHelper
  def set_title(title)
    content_for(:title, [title, t('general.title')].join(" | "))
    title
  end

  def set_meta_data(description:, thumbnail:, url:)
    content_for(:description, description) unless description.nil?
    content_for(:thumbnail, full_url_for(thumbnail)) unless thumbnail.nil?
    content_for(:share_url, url || request.original_url)
  end
end
