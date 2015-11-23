class PeopleController < ApplicationController

  before_action :load_person_and_declarations, only: [:show, :contact]

  def index
    @people = Person.all.includes(:party)
  end

  def show

    @contact = Contact.new(person: @person)
  end

  def contact
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

    def load_person_and_declarations
      @person = Person.find(params[:id])
      @assets_declarations = @person.assets_declarations.order(:declaration_date)
      @activities_declarations = @person.activities_declarations.order(:declaration_date)
    end


end
