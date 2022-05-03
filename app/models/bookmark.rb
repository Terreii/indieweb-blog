class Bookmark < ApplicationRecord
  def published_at
    created_at
  end
end
