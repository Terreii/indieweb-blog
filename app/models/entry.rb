class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[]
end
