smtp_address = ENV["SMTP_ADDRESS"]

if smtp_address.present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    address: smtp_address,
    port: ENV.fetch("SMTP_PORT", "587").to_i,
    user_name: ENV.fetch("SMTP_USERNAME"),
    password: ENV.fetch("SMTP_PASSWORD"),
    authentication: :plain,
    enable_starttls_auto: true
  }
elsif Rails.env.development?
  Rails.application.config.action_mailer.delivery_method = :file
  Rails.application.config.action_mailer.file_settings = { location: Rails.root.join("tmp/mail") }
end
