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
  attribute :case_study, default: -> { {} }

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

    def find!(id)
      find(id) || raise(NotFound, id)
    end

    private

    def load_items
      data = YAML.load_file(Rails.root.join("config/portfolio.yml"))
      data.fetch("items", []).map { |attrs| new(attrs) }
    end
  end

  class NotFound < StandardError; end

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

  def path
    "/portfolio/#{id}"
  end

  def concept?
    case_study["type"].to_s.downcase.include?("concept")
  end

  def real_project?
    !concept?
  end

  def case_study_summary
    case_study["summary"]
  end

  def case_study_role
    case_study["role"]
  end

  def case_study_contributions
    Array(case_study["contributions"])
  end

  def case_study_challenges
    Array(case_study["challenges"])
  end

  def case_study_stack
    case_study["stack"].is_a?(Hash) ? case_study["stack"] : {}
  end
end
