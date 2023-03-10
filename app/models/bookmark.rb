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
  include Entryable

  validates :url, presence: true, format: { with: URI.regexp }

  has_and_belongs_to_many :authors
  has_rich_text :summary

  default_scope { with_all_rich_text }

  def published_at
    created_at
  end
end
