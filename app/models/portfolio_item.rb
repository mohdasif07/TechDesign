class PortfolioItem
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :category, :string
  attribute :tag, :string
  attribute :title, :string
  attribute :description, :string
  attribute :visual, :string
  attribute :location, :string

  CATEGORIES = %w[tech interior].freeze

  class << self
    def all
      @all ||= load_items
    end

    def by_category(category)
      return all if category.blank? || category == "all"

      all.select { |item| item.category == category }
    end

    def find(id)
      all.find { |item| item.id == id }
    end

    private

    def load_items
      data = YAML.load_file(Rails.root.join("config/portfolio.yml"))
      data.fetch("items", []).map { |attrs| new(attrs) }
    end
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

  def work_card_class
    "work-#{visual}"
  end
end
