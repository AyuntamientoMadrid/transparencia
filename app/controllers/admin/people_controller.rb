class Admin::PeopleController < Admin::BaseController

  before_action :load_parties, only: %i(new create edit update destroy)

  def hidden_people
    @people = Person.hidden.order(:role, :last_name, :first_name)
  end

  def index
    @people = Person.unhidden.order(:role, :last_name, :first_name)
  end

  def new
    @person = Person.new
  end

  def create
    if Person.create(person_params)
      redirect_to admin_people_path, notice: I18n.t("people.notice.created")
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
      redirect_to admin_people_path, notice: I18n.t('people.notice.updated')
    else
      render :edit
    end
  end

  def destroy
    Person.friendly.find(params[:id]).destroy
    redirect_to admin_people_path, notice: I18n.t('people.notice.deleted')
  end

  def hide
    @person = Person.friendly.find(params[:person_id])
    hidden_at = Date.parse(person_params[:hidden_at]) rescue DateTime.current
    @person.hide(current_administrator, person_params[:hidden_reason], hidden_at)
    redirect_to admin_people_path(@person), notice: I18n.t('people.notice.hidden')
  end

  def unhide
    @person = Person.friendly.find(params[:person_id])
    unhidden_at = Date.parse(person_params[:unhidden_at]) rescue DateTime.current
    @person.unhide(current_administrator, person_params[:unhidden_reason], unhidden_at)
    redirect_to admin_people_path(@person), notice: I18n.t('people.notice.unhidden')
  end

  private

    def person_params
      params.require(:person).permit(
        :first_name, :last_name, :job_level, :area, :councillor_code, :personal_code,
        :twitter, :facebook, :role, :secondary_role, :unit, :party_id,
        :studies_comment, :courses_comment, :career_comment, :political_posts_comment,
        :public_jobs_level, :public_jobs_body, :public_jobs_start_year,
        :publications, :teaching_activity, :special_mentions, :other,
        :hidden_at, :hidden_reason, :updated_at,
        :unhidden_at, :unhidden_reason, :calendar_url, :portrait,
        studies_attributes: %i(description entity start_year end_year),
        courses_attributes: %i(description entity start_year end_year),
        private_jobs_attributes: %i(description entity start_year end_year),
        public_jobs_attributes: %i(description entity start_year end_year),
        political_posts_attributes: %i(description entity start_year end_year),
        languages_attributes: %i(name level)
      )
    end

    def load_parties
      @parties = Party.all.order(:name)
    end

end