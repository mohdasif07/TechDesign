class BlogPost
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :slug, :string
  attribute :title, :string
  attribute :excerpt, :string
  attribute :category, :string
  attribute :published_at, :string
  attribute :read_time, :string
  attribute :body, :string

  class << self
    def all
      @all ||= load_posts.sort_by { |post| post.published_at.to_s }.reverse
    end

    def find(slug)
      all.find { |post| post.slug == slug }
    end

    def recent(limit = 3)
      all.first(limit)
    end

    private

    def load_posts
      data = YAML.load_file(Rails.root.join("config/blog_posts.yml"))
      data.fetch("posts", []).map { |attrs| new(attrs) }
    end
  end

  def published_date
    Date.parse(published_at)
  rescue ArgumentError, TypeError
    Date.current
  end

  def formatted_date
    published_date.strftime("%d %b %Y")
  end

  def interior?
    category == "interior"
  end

  def tech?
    category == "tech"
  end

  def category_label
    interior? ? "Interior Design" : "IT Development"
  end
end
