class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "Arqvexa <hello@arqvexa.in>")
  layout "mailer"
end
