# == Schema Information
#
# Table name: entries
#
#  id             :bigint           not null, primary key
#  entryable_type :string           not null
#  language       :enum             default("english"), not null
#  published_at   :datetime
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  entryable_id   :bigint           not null
#
# Indexes
#
#  index_entries_on_entryable     (entryable_type,entryable_id)
#  index_entries_on_published_at  (published_at)
#
class Entry < ApplicationRecord
  def self.types
    %w[ Bookmark Post ]
  end

  # Get the params permit attributes keys for Entry.
  # Also add entryable_attributes for delegated types.
  def self.permitted_attributes_with(*entryable_attributes)
    [:title, :published, :language, tag_ids: [], entryable_attributes:]
  end

  enum language: {
    english: "en", german: "de"
  }, _prefix: true

  delegated_type :entryable, types: self.types, dependent: :destroy
  accepts_nested_attributes_for :entryable, update_only: true
  has_and_belongs_to_many :tags

  validates :title, presence: true

  scope :with_entryables, -> { preload(:entryable, :tags) }
  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }
  scope :bookmarks, -> { where(entryable_type: Bookmark.name).preload(:entryable, :tags) }
  scope :posts, -> { where(entryable_type: Post.name).preload(:entryable, :tags) }

  before_validation :set_self_on_new_entryable

  broadcasts_to ->(entry) { "admin_entries" }, inserts_by: :prepend, partial: "admin/overview/entry"

  def published?
    published_at.present?
  end

  alias_method :published, :published?

  def published=(is_published)
    is_published = is_published == "1" || is_published == "true" if is_published.instance_of? String
    return published? if published? == is_published
    self.published_at = is_published ? Time.now : nil
    published?
  end

  # Get the IANA tag of language
  def language_code
    self.class.languages[language]
  end

  private

    # Sets the entry property of an entryable model to self.
    # This way, it can be created in one go.
    # Normaly the entry reference is only set once both models are saved,
    # but for new entries, it is not. Which doesn't allow it to use
    # it for validations.
    def set_self_on_new_entryable
      return unless entryable.entry.nil?
      entryable.entry = self
    end
end
