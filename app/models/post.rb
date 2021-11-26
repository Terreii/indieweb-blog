class Post < ApplicationRecord
  validates :title, presence: true

  has_rich_text :body

  scope :published, -> { where.not(published_at: nil) }
  scope :draft, -> { where(published_at: nil) }

  def published?
    published_at.present?
  end
end
