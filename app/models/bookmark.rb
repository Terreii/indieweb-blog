# == Schema Information
#
# Table name: bookmarks
#
#  id  :bigint           not null, primary key
#  url :string
#
# Indexes
#
#  index_bookmarks_on_url  (url) UNIQUE
#
class Bookmark < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :url, presence: true, format: { with: URI.regexp }

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :tags
  has_rich_text :summary

  default_scope { order created_at: :desc }

  def published_at
    created_at
  end
end
