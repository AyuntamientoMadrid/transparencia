class PeopleController < ApplicationController

  before_action :load_person_and_declarations, only: [:show, :contact]

  def index
    redirect_to councillors_people_path
  end

  def councillors
    @working_councillors_by_party = Person.councillors.working.unhidden.grouped_by_party
    @not_working_councillors      = Person.councillors.not_working # hidden councillors == not_working councillors
  end

  def directors
    @directors_by_name_initial = Person.directors.unhidden.grouped_by_name_initial
  end

  def temporary_workers
    @temporary_workers_by_name_initial = Person.temporary_workers.unhidden.grouped_by_name_initial
  end

  def public_workers
    @public_workers_by_name_initial = Person.public_workers.unhidden.grouped_by_name_initial
  end

  def spokespeople
    @spokespeople_by_name_initial = Person.spokespeople.unhidden.grouped_by_name_initial
  end

  def labours
    @labours_by_name_initial = Person.labours.unhidden.grouped_by_name_initial
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
      @person = Person.friendly.find(params[:id])
      authorize_administrators if (@person.hidden? && !@person.councillor?)
      @assets_declarations = @person.assets_declarations.order(:declaration_date)
      @activities_declarations = @person.activities_declarations.order(:declaration_date)
    end

    def full_feature?
      true
    end

end
