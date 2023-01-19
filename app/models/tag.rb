class Tag < ApplicationRecord
  validates :name, format: {
    with: /\A[a-z0-9][a-z0-9\-_]*[a-z0-9]\z/,
    message: "can only include a-z, 0-9, - and _"
  }

  has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :posts

  default_scope { order :name }

  def to_param
    name
  end

  after_create_commit {
    broadcast_append_later_to "tags", target: "post_tags_list", partial: "tags/checkbox", locals: {
      tag: self,
      model_name: "entry[entryable_attributes]"
    }
    broadcast_append_later_to "tags", target: "bookmark_tags_list", partial: "tags/checkbox", locals: {
      tag: self,
      model_name: "bookmark"
    }
  }
end
