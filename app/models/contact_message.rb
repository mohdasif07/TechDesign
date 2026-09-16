class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :phone, :string
  attribute :company, :string
  attribute :service, :string
  attribute :project_type, :string
  attribute :budget_range, :string
  attribute :timeline, :string
  attribute :message, :string
  attribute :website, :string
  attribute :return_to, :string

  SERVICES = [
    "Interior Design",
    "IT Development",
    "Both services",
    "General enquiry"
  ].freeze

  PROJECT_TYPES = [
    "Business website",
    "Web application",
    "Mobile app",
    "E-commerce",
    "Custom software / CRM",
    "AI / automation",
    "API integration",
    "Interior design",
    "Not sure yet"
  ].freeze

  BUDGET_RANGES = [
    "Under ₹50,000",
    "₹50,000 – ₹1.5L",
    "₹1.5L – ₹5L",
    "₹5L+",
    "Prefer to discuss"
  ].freeze

  TIMELINES = [
    "ASAP / under 4 weeks",
    "1–2 months",
    "3+ months",
    "Exploring options"
  ].freeze

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :company, length: { maximum: 120 }, allow_blank: true
  validates :service, inclusion: { in: SERVICES }, allow_blank: true
  validates :project_type, inclusion: { in: PROJECT_TYPES }, allow_blank: true
  validates :budget_range, inclusion: { in: BUDGET_RANGES }, allow_blank: true
  validates :timeline, inclusion: { in: TIMELINES }, allow_blank: true
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }

  def spam?
    website.present?
  end
end
