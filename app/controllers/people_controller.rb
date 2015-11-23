class PeopleController < ApplicationController

  def index
    @people = Person.all.includes(:party)
  end

  def show
    @person = Person.find(params[:id])
    @contact = Contact.new(person: @person)
  end

  def contact
    @person = Person.find(params[:id])
    @contact = Contact.new(contact_params.merge(person: @person))

    if @contact.valid?
      Mailer.new_contact(@contact).deliver_now
      redirect_to person_path(@person, anchor: :contact), contact_notice: I18n.t("people.contact.success")
    else
      flash[:contact_alert] = I18n.t('people.contact.error')
      render :show
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :body)
    end

end
