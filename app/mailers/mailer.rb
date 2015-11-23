class Mailer < ApplicationMailer

  def new_contact(contact)
    @contact = contact

    mail to: @contact.person.email,
         subject: I18n.t("mailer.new_contact.subject", email: contact.name)
  end

end
