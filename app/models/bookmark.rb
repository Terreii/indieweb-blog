class Bookmark < ApplicationRecord
  default_scope { order created_at: :desc }

  def published_at
    created_at
  end
end
