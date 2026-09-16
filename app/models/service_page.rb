class ServicePage
  include ActiveModel::Model
  include ActiveModel::Attributes

  class NotFound < StandardError; end

  DIVISIONS = {
    interior: "interior-design",
    it: "it-development"
  }.freeze

  attribute :slug, :string
  attribute :division, :string
  attribute :title, :string
  attribute :meta_title, :string
  attribute :meta_description, :string
  attribute :meta_keywords, :string
  attribute :h1, :string
  attribute :intro, :string
  attribute :cta_label, :string
  attribute :sections, default: -> { [] }
  attribute :process, default: -> { [] }
  attribute :benefits, default: -> { [] }
  attribute :faqs, default: -> { [] }
  attribute :related_slugs, default: -> { [] }
  attribute :related_portfolio_ids, default: -> { [] }

  # Top-level public URLs for IT service pages (SEO-friendly).
  IT_TOP_LEVEL_SLUGS = %w[
    web-development
    website-development
    mobile-app-development
    software-development
    ai-development
    ai-automation
    ecommerce-development
    crm-development
    api-integration
  ].freeze

  LEGACY_PATH_REDIRECTS = {
    "custom-software-development" => "/software-development",
    "api-development" => "/api-integration"
  }.freeze

  class << self
    def all
      @all ||= load_pages
    end

    def reload!
      @all = nil
      all
    end

    def for_division(division)
      all.select { |page| page.division == division.to_s }
    end

    def find!(division, slug)
      page = all.find { |item| item.division == division.to_s && item.slug == slug }
      raise NotFound unless page

      page
    end

    def it_top_level_constraint
      Regexp.union(IT_TOP_LEVEL_SLUGS)
    end

    def legacy_redirect_path(slug)
      LEGACY_PATH_REDIRECTS[slug] || (IT_TOP_LEVEL_SLUGS.include?(slug) ? "/#{slug}" : nil)
    end

    private

    def load_pages
      paths = [
        Rails.root.join("config/interior_services.yml"),
        Rails.root.join("config/it_services.yml")
      ]

      paths.flat_map do |path|
        data = YAML.load_file(path)
        data.fetch("pages", []).map { |attrs| new(attrs) }
      end
    end
  end

  def interior?
    division == "interior"
  end

  def it?
    division == "it"
  end

  def hub_path
    interior? ? "/interior-design" : "/it-development"
  end

  def path
    interior? ? "#{hub_path}/#{slug}" : "/#{slug}"
  end

  def hub_label
    interior? ? "Interior Design" : "IT Development"
  end

  def related_pages
    related_slugs.filter_map do |related_slug|
      self.class.all.find { |page| page.slug == related_slug && page.division == division }
    end
  end

  def related_portfolio_items
    related_portfolio_ids.filter_map { |id| PortfolioItem.find(id) }
  end

  def default_cta_label
    interior? ? "Book an Interior Design Consultation" : "Discuss Your Software Project"
  end

  def cta_text
    cta_label.presence || default_cta_label
  end

  def contact_service_label
    interior? ? "Interior Design" : "IT Development"
  end
end
