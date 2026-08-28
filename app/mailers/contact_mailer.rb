class ContactMailer < ApplicationMailer
  def enquiry(contact)
    @contact = contact

    mail(
      to: ENV.fetch("CONTACT_EMAIL", "mohdasif.dev01@gmail.com"),
      reply_to: contact.email,
      subject: "New enquiry — #{contact.service.presence || 'AS DesignTech'} — #{contact.name}"
    )
  end
end
