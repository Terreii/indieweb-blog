class Post < ApplicationRecord
  validates :title, :slug, presence: true
  validates :slug, length: { in: 5..100 }

  has_rich_text :body

  before_validation :generate_slug

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :draft, -> { where(published_at: nil) }

  def published?
    published_at.present?
  end

  private

    def generate_slug
      return if slug.present?
      self.slug = title.strip
        .downcase
        .gsub(/\s+/, '-')
        .gsub(/['".,:;<>(){}\[\]*#]/, '')
        .gsub(/[äöüß]/, {
          'ä' => 'ae',
          'ö' => 'oe',
          'ü' => 'ue',
          'ß' => 'ss'
        })
    end
end
