class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :phone, :string
  attribute :service, :string
  attribute :message, :string
  attribute :website, :string
  attribute :return_to, :string

  SERVICES = [
    "Interior Design",
    "IT Development",
    "Both services",
    "General enquiry"
  ].freeze

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :service, inclusion: { in: SERVICES }, allow_blank: true
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }

  def spam?
    website.present?
  end
end
