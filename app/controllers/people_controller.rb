class PeopleController < ApplicationController

  before_action :authorize_administrators, only: [:new, :create, :edit, :update, :destroy, :hide, :unhide]
  before_action :load_parties, only: [:new, :create, :edit, :update, :destroy]
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

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to person_path(@person), notice: I18n.t("people.notice.created")
    else
      render :new
    end
  end

  def edit
    @person = Person.friendly.find(params[:id])
  end

  def update
    @person = Person.friendly.find(params[:id])
    if @person.update(person_params)
      redirect_to person_path(@person), notice: I18n.t('people.notice.updated')
    else
      render :edit
    end
  end

  def hide
    @person = Person.friendly.find(params[:id])
    hidden_at = Date.parse(person_params[:hidden_at]) rescue DateTime.current
    @person.hide(current_administrator, person_params[:hidden_reason], hidden_at)
    redirect_to person_path(@person), notice: I18n.t('people.notice.hidden')
  end

  def unhide
    @person = Person.friendly.find(params[:id])
    unhidden_at = Date.parse(person_params[:unhidden_at]) rescue DateTime.current
    @person.unhide(current_administrator, person_params[:unhidden_reason], unhidden_at)
    redirect_to person_path(@person), notice: I18n.t('people.notice.unhidden')
  end

  def destroy
    @person = Person.friendly.find(params[:id])
    @person.destroy
    path = @person.councillor? ? councillors_people_path : directors_people_path
    redirect_to path, notice: I18n.t("people.notice.deleted")
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

    def person_params
      params.require(:person).permit(
        :first_name, :last_name, :job_level, :area, :councillor_code, :personal_code,
        :twitter, :facebook, :role, :secondary_role, :unit, :party_id,
        :studies_comment, :courses_comment, :career_comment, :political_posts_comment,
        :public_jobs_level, :public_jobs_body, :public_jobs_start_year,
        :publications, :teaching_activity, :special_mentions, :other,
        :hidden_at, :hidden_reason,
        :unhidden_at, :unhidden_reason,
        :calendar_url,
        studies_attributes: [:description, :entity, :start_year, :end_year],
        courses_attributes: [:description, :entity, :start_year, :end_year],
        private_jobs_attributes: [:description, :entity, :start_year, :end_year],
        public_jobs_attributes: [:description, :entity, :start_year, :end_year],
        political_posts_attributes: [:description, :entity, :start_year, :end_year],
        languages_attributes: [:name, :level]
      )
    end

    def load_parties
      @parties = Party.all.order(:name)
    end

    def full_feature?
      true
    end

end
