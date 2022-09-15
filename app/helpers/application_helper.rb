module ApplicationHelper
  def set_title(title)
    content_for(:title, [title, t('general.title')].join(" | "))
    title
  end

  def set_meta_data(description:, thumbnail:, url:)
    content_for(:description, description) unless description.nil?
    if thumbnail.nil?
      content_for(:thumbnail, gravatar_url(200))
      content_for(:thumbnail_whith, 200)
      content_for(:thumbnail_height, 200)
    else
      content_for(:thumbnail, full_url_for(thumbnail))
      content_for(:thumbnail_whith, thumbnail.metadata["width"])
      content_for(:thumbnail_height, thumbnail.metadata["height"])
    end
    content_for(:share_url, url || request.original_url)
  end

  def gravatar_url(size = nil)
    url = "https://www.gravatar.com/avatar/#{Rails.application.credentials.gravatar}"
    return "#{url}?s=#{size}" unless size.nil?
    url
  end
end
