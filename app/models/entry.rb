class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Post ], dependent: :destroy
  accepts_nested_attributes_for :entryable

  validates :title, presence: true

  scope :with_entryables, -> { includes(:entryable) }
  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }
  scope :posts, -> { where(entryable_type: Post.name).includes(:entryable) }

  def self.create_with_post(args)
    published = args[:published] || false
    args.delete :published
    args => {title:, **rest}
    post = Post.new(rest.merge slug: Post.string_to_slug(title))
    entry = create!(title:, entryable: post)
    entry.update(published: published) if published
    entry
  end

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
end
