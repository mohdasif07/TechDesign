class ContactsController < ApplicationController
  def create
    @contact_message = ContactMessage.new(contact_params)

    if @contact_message.spam?
      redirect_to redirect_path, notice: "Thank you! We will get back to you within 24 hours."
      return
    end

    unless @contact_message.valid?
      redirect_to redirect_path, alert: @contact_message.errors.full_messages.to_sentence
      return
    end

    unless ContactNotifier.configured?
      redirect_to redirect_path, alert: "Email is not configured yet. Please WhatsApp us or email mohdasif.dev01@gmail.com directly."
      return
    end

    ContactNotifier.deliver(@contact_message)
    redirect_to redirect_path, notice: "Message sent successfully! We will reply within 24 hours."
  rescue ContactNotifier::DeliveryError, StandardError => e
    Rails.logger.error("[ContactNotifier] #{e.class}: #{e.message}")
    redirect_to redirect_path, alert: "Could not send your message right now. Please WhatsApp us or email mohdasif.dev01@gmail.com directly."
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :phone, :service, :message, :website, :return_to)
  end

  def redirect_path
    path = contact_params[:return_to].to_s
    return path if path.start_with?("/")

    root_path(anchor: "contact")
  end
end
