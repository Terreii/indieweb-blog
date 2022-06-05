class Bookmark < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :url, presence: true, format: { with: URI.regexp }

  has_and_belongs_to_many :authors
  has_rich_text :summary

  default_scope { order created_at: :desc }

  def published_at
    created_at
  end
end
