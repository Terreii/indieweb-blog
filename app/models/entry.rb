class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Post ], dependent: :destroy
  accepts_nested_attributes_for :entryable, update_only: true
  has_and_belongs_to_many :tags

  validates :title, presence: true

  scope :with_entryables, -> { includes(:entryable) }
  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }
  scope :posts, -> { where(entryable_type: Post.name).includes(:entryable) }

  before_validation :set_self_on_new_entryable

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
