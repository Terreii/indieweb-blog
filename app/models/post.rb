class Post < ApplicationRecord
  include Entryable

  validates :slug, presence: true, length: { in: 3..128 }
  validates :slug, format: { with: /\A[a-z0-9][a-z0-9\-_]+[a-z0-9]\z/ }
  validates :summary, length: { minimum: 3, maximum: 200 }

  has_and_belongs_to_many :tags
  has_one_attached :thumbnail
  has_rich_text :body

  before_validation :ensure_slug_has_a_value
  before_validation :ensure_summary_has_a_value
  before_validation :trim_summary

  default_scope do
    with_all_rich_text
      .with_attached_thumbnail
      .preload(:tags)
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
      .gsub(/[äöüß]/, {
        'ä' => 'ae',
        'ö' => 'oe',
        'ü' => 'ue',
        'ß' => 'ss'
      })
      .gsub(/[^a-z0-9\-_]/, '')
  end

  private

    def ensure_slug_has_a_value
      if slug.nil? || slug.blank?
        self.slug = Post.string_to_slug(entry.title) unless entry.title.nil? || entry.title.blank?
      end
    end

    def ensure_summary_has_a_value
      return unless !summary? && body?
      body_doc = Nokogiri.HTML5 body.to_s
      self.summary = body_doc.at_css(".trix-content > *").content
    end

    def trim_summary
      return if !summary? || summary.length <= 200
      self.summary = self.summary.truncate 200
    end
end
