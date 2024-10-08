# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Tag < ApplicationRecord
  validates :name, format: {
    with: /\A[a-z0-9][a-z0-9\-_]*[a-z0-9]\z/,
    message: "can only include a-z, 0-9, - and _"
  }

  has_and_belongs_to_many :entries

  default_scope { order :name }

  def to_param
    name
  end

  after_create_commit {
    broadcast_append_later_to "tags", target: "tags_list", partial: "tags/checkbox", locals: {
      tag: self
    }
  }
end
