class LocationPage
  include ActiveModel::Model
  include ActiveModel::Attributes

  class NotFound < StandardError; end

  CITY_SLUGS = %w[budaun bareilly aligarh moradabad].freeze

  DIVISIONS = {
    interior: "interior-design",
    web: "web-development"
  }.freeze

  attribute :slug, :string
  attribute :division, :string
  attribute :city, :string
  attribute :state, :string, default: "Uttar Pradesh"
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
  attribute :related_service_slugs, default: -> { [] }
  attribute :related_city_slugs, default: -> { [] }

  class << self
    def all
      @all ||= load_pages
    end

    def city_slugs
      CITY_SLUGS
    end

    def for_division(division)
      all.select { |page| page.division == division.to_s }
    end

    def find!(division, slug)
      page = all.find { |item| item.division == division.to_s && item.slug == slug }
      raise NotFound unless page

      page
    end

    private

    def load_pages
      data = YAML.load_file(Rails.root.join("config/location_pages.yml"))
      data.fetch("pages", []).map { |attrs| new(attrs) }
    end
  end

  def interior?
    division == "interior"
  end

  def web?
    division == "web"
  end

  def hub_path
    interior? ? "/interior-design" : "/web-development"
  end

  def hub_url_path
    interior? ? "/interior-design" : "/it-development"
  end

  def path
    "#{hub_path}/#{slug}"
  end

  def hub_label
    interior? ? "Interior Design" : "Web Development"
  end

  def contact_service_label
    interior? ? "Interior Design" : "IT Development"
  end

  def default_cta_label
    interior? ? "Book an Interior Design Consultation" : "Discuss Your Software Project"
  end

  def cta_text
    cta_label.presence || default_cta_label
  end

  def related_services
    related_service_slugs.filter_map do |service_slug|
      ServicePage.all.find { |page| page.slug == service_slug && page.division == (interior? ? "interior" : "it") }
    end
  end

  def related_cities
    related_city_slugs.filter_map do |city_slug|
      self.class.all.find { |page| page.slug == city_slug && page.division == division }
    end
  end

  def related_portfolio_items
    PortfolioItem.all.select { |item| item.location.to_s.match?(/#{Regexp.escape(city)}/i) }.first(3)
  end

  def service_area_label
    "#{city}, #{state}"
  end
end
