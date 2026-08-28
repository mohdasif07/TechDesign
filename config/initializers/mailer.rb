smtp_address = ENV["SMTP_ADDRESS"]
smtp_username = ENV["SMTP_USERNAME"]
smtp_password = ENV["SMTP_PASSWORD"]

if smtp_address.present? && smtp_username.present? && smtp_password.present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.perform_deliveries = true
  Rails.application.config.action_mailer.smtp_settings = {
    address: smtp_address,
    port: ENV.fetch("SMTP_PORT", "587").to_i,
    user_name: smtp_username,
    password: smtp_password,
    authentication: :plain,
    enable_starttls_auto: true
  }
elsif Rails.env.development?
  Rails.application.config.action_mailer.delivery_method = :file
  Rails.application.config.action_mailer.file_settings = { location: Rails.root.join("tmp/mail") }
else
  Rails.application.config.action_mailer.perform_deliveries = false
  Rails.logger.info("[Mailer] SMTP not configured — contact form emails disabled until SMTP_USERNAME and SMTP_PASSWORD are set.")
end
