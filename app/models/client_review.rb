class ClientReview
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :division, :string
  attribute :name, :string
  attribute :role, :string
  attribute :location, :string
  attribute :project, :string
  attribute :quote, :string
  attribute :rating, :integer, default: 5

  DIVISIONS = %w[interior it].freeze

  class << self
    def all
      @all ||= load_reviews
    end

    def for_division(division)
      all.select { |review| review.division == division.to_s }
    end

    private

    def load_reviews
      data = YAML.load_file(Rails.root.join("config/client_reviews.yml"))
      data.fetch("reviews", []).map { |attrs| new(attrs) }
    end
  end

  def interior?
    division == "interior"
  end

  def it?
    division == "it"
  end

  def initials
    name.to_s.scan(/[A-Za-z]/).first(2).join.upcase.presence || "AR"
  end
end
