class ContactNotifier
  class DeliveryError < StandardError; end

  # Web3Forms must run in the browser (free tier blocks server-side calls).
  # See app/javascript/application.js — initContactForm.
  def self.deliver(contact)
    if smtp_configured? || Rails.env.development?
      ContactMailer.enquiry(contact).deliver_now
    else
      raise DeliveryError, "No server-side email delivery configured"
    end
  end

  def self.configured?
    web3forms_configured? || smtp_configured? || Rails.env.development?
  end

  def self.web3forms_configured?
    ENV["WEB3FORMS_ACCESS_KEY"].present?
  end

  def self.smtp_configured?
    ENV["SMTP_ADDRESS"].present? && ENV["SMTP_USERNAME"].present? && ENV["SMTP_PASSWORD"].present?
  end
end
