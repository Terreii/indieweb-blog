json.extract! entry, :id, :title, :published_at, :created_at, :updated_at
json.partial! "entries/entryables/#{entry.entryable_name}", entry.entryable_type.downcase.to_sym => entry.entryable
json.tags do
  json.array! entry.tags.pluck :name
end
