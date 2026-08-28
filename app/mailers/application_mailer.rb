class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "AS DesignTech <mohdasif.dev01@gmail.com>")
  layout "mailer"
end
