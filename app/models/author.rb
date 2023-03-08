# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  photo      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authors_on_name  (name)
#  index_authors_on_url   (url)
#
class Author < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }

  has_and_belongs_to_many :bookmarks
end
