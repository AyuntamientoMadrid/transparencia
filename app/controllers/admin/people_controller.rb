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
    @person.activities_declarations.build
    @person.assets_declarations.build
  end

  def create
    short_person_params = person_params
    short_person_params.delete(:activities_declarations_attributes)
    short_person_params.delete(:assets_declarations_attributes)
    @person = Person.new(short_person_params)
    if @person.save & add_new_activities_declaration(person_params, @person) & add_new_assets_declaration(person_params, @person)
      @person.activities_declarations.build
      @person.assets_declarations.build
      redirect_to admin_people_path, notice: I18n.t("people.notice.created")
    else
      render :new
    end
  end

  def edit
    @person = Person.friendly.find(params[:id])
    @person.activities_declarations.build
    @person.assets_declarations.build
  end

  def update
    @person = Person.friendly.find(params[:id])
    local_person_params = person_params
    if add_new_activities_declaration(local_person_params, @person) &
       add_new_assets_declaration(local_person_params, @person) &
       @person.update(local_person_params)

      @person.activities_declarations.build
      @person.assets_declarations.build
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
    hidden_at = person_params[:hidden_at].nil? ? DateTime.current : Date.parse(person_params[:hidden_at])
    @person.hide(current_administrator, person_params[:hidden_reason], hidden_at)
    redirect_to admin_people_path(@person), notice: I18n.t('people.notice.hidden')
  end

  def unhide
    @person = Person.friendly.find(params[:person_id])
    unhidden_at = person_params[:unhidden_at].nil? ? DateTime.current : Date.parse(person_params[:unhidden_at])
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
        languages_attributes: %i(name level),
        activities_declarations_attributes: [
          :id, :declaration_date, :period,
          public_activities_attributes: %i(entity position start_date end_date),
          private_activities_attributes: %i(kind description entity position start_date end_date),
          other_activities_attributes: %i(description start_date end_date)
        ],
        assets_declarations_attributes: [
          :id, :declaration_date, :period,
          real_estate_properties_attributes: %i(kind type description municipality share purchase_date tax_value notes),
          account_deposits_attributes: %i(kind banking_entity balance),
          other_deposits_attributes: %i(kind description amount purchase_date),
          vehicles_attributes: %i(kind model purchase_date),
          other_personal_properties_attributes: %i(kind purchase_date),
          debts_attributes: %i(kind amount comments)
        ]
      )
    end

    def add_new_activities_declaration(data, person)
      data[:activities_declarations_attributes]['0'].delete('id')
      person.activities_declarations.build(data[:activities_declarations_attributes]['0'])
      declaration = person.activities_declarations.last
      data[:activities_declarations_attributes].delete('0')
      output = true
      if person.activities_declarations.last.complete_values.compact != [""]
        output = declaration.save
      else
        person.activities_declarations.last.destroy
      end
      output
    end

    def add_new_assets_declaration(data, person)
      data[:assets_declarations_attributes]['0'].delete('id')
      person.assets_declarations.build(data[:assets_declarations_attributes]['0'])
      declaration = person.assets_declarations.last
      data[:assets_declarations_attributes].delete('0')
      output = true
      if person.assets_declarations.last.complete_values.compact != [""]
        output = declaration.save
      else
        person.assets_declarations.last.destroy
      end
      output
    end

    def load_parties
      @parties = Party.all.order(:name)
    end

end