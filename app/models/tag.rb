class Tag < ApplicationRecord
  validates :name, format: { with: /\A[a-z0-9][a-z0-9\-_]*[a-z0-9]\z/ }

  has_and_belongs_to_many :posts

  default_scope { order(:name) }

  def to_param
    name
  end
end
