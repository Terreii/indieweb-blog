module ApplicationHelper
  def set_title(title)
    content_for(:title, [title, t('general.title')].join(" | "))
    title
  end

  def set_meta_data(description:, thumbnail:, url:)
    content_for(:description, description) unless description.nil?
    content_for(:thumbnail, thumbnail.nil? ? gravatar_url : full_url_for(thumbnail))
    content_for(:share_url, url || request.original_url)
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{Rails.application.credentials.gravatar}"
  end
end
