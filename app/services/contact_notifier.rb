class ContactNotifier
  class DeliveryError < StandardError; end

  def self.deliver(contact)
    if web3forms_configured?
      deliver_via_web3forms(contact)
    elsif smtp_configured? || Rails.env.development?
      ContactMailer.enquiry(contact).deliver_now
    else
      raise DeliveryError, "No email delivery configured"
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

  def self.deliver_via_web3forms(contact)
    require "net/http"
    require "json"

    uri = URI("https://api.web3forms.com/submit")
    payload = {
      access_key: ENV["WEB3FORMS_ACCESS_KEY"],
      subject: "New enquiry — #{contact.service.presence || 'AS DesignTech'} — #{contact.name}",
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      service: contact.service,
      message: contact.message,
      from_name: "AS DesignTech Website",
      replyto: contact.email
    }

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 15) do |http|
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = payload.to_json
      http.request(request)
    end

    data = JSON.parse(response.body)
    return if data["success"]

    raise DeliveryError, data["message"].presence || "Web3Forms request failed"
  rescue JSON::ParserError
    raise DeliveryError, "Invalid response from email service"
  end

  private_class_method :deliver_via_web3forms
end
