class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Post ]
  accepts_nested_attributes_for :entryable

  validates :title, :slug, presence: true

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }

  def published?
    published_at.present?
  end

  alias_method :published, :published?

  def published=(is_published)
    is_published = is_published == "1" || is_published == "true" if is_published.instance_of? String
    return published? if published? == is_published
    self.published_at = is_published ? Time.now : nil
    published?
  end
end
