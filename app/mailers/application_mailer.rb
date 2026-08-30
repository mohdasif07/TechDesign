class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "Arqvexa <mohdasif.dev01@gmail.com>")
  layout "mailer"
end
