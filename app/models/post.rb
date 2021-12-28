class Post < ApplicationRecord
  validates :title, :slug, presence: true
  validates :slug, length: { in: 5..128 }

  has_rich_text :body

  before_validation :generate_slug

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }

  def published?
    published_at.present?
  end

  def to_param
    slug
  end

  def self.string_to_slug(text)
    slug = text.strip
    first_dot = slug.index('.', 5) || 125
    slug[0, first_dot]
      .downcase
      .gsub(/\s+/, '-')
      .gsub(/['"!?.,:;<>(){}\[\]*#]/, '')
      .gsub(/[äöüß]/, {
        'ä' => 'ae',
        'ö' => 'oe',
        'ü' => 'ue',
        'ß' => 'ss'
      })
  end

  private

    def generate_slug
      return if slug.present?
      self.slug = Post.string_to_slug title
    end
end
