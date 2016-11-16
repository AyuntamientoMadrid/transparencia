class PeopleController < ApplicationController

  before_action :authorize_administrators, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_parties, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_person_and_declarations, only: [:show, :contact]

  def index
    redirect_to councillors_people_path
  end

  def councillors
    @people_groups = Person.councillors.grouped_by_party
  end

  def directors
    @people_groups = Person.directors.grouped_by_name_initial
  end

  def temporary_workers
    @people_groups = Person.temporary_workers.grouped_by_name_initial
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
      redirect_to person_path(@person), notice: I18n.t("people.notice.updated")
    else
      render :edit
    end
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
      @assets_declarations = @person.assets_declarations.order(:declaration_date)
      @activities_declarations = @person.activities_declarations.order(:declaration_date)
    end

    def person_params
      params.require(:person).permit(
        :first_name, :last_name, :job_level, :area, :councillor_code, :personal_code,
        :twitter, :facebook, :role, :unit, :party_id,
        :studies_comment, :courses_comment, :career_comment, :political_posts_comment,
        :public_jobs_level, :public_jobs_body, :public_jobs_start_year,
        :publications, :teaching_activity, :special_mentions, :other,
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
