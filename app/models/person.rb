require 'sorting_name_calculator'

class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  include ParseDataRows

  belongs_to :party
  belongs_to :hidden_by, class_name: 'Administrator'
  belongs_to :unhidden_by, class_name: 'Administrator'

  has_many :assets_declarations, -> { sort_for_list }, dependent: :destroy
  has_many :activities_declarations, -> { sort_for_list }, dependent: :destroy

  def self.job_levels
    %W{councillor director temporary_worker}
  end

  def self.orders
    %w{party_name area name_initial}
  end

  validates :first_name,   presence: true
  validates :last_name,   presence: true
  validates :role,   presence: true
  validates :job_level, presence: true
  validates :job_level, inclusion: { in: Person.job_levels }

  scope :councillors,       -> { where(job_level: 'councillor') }
  scope :directors,         -> { where(job_level: 'director') }
  scope :temporary_workers, -> { where(job_level: 'temporary_worker') }
  scope :working,           -> { where(leaving_date: nil) }
  scope :not_working,       -> { where.not(leaving_date: nil).order(:leaving_date) }

  scope :unhidden, -> { where('people.hidden_at IS NULL OR (people.unhidden_at IS NOT NULL AND people.unhidden_at > people.hidden_at)') }
  scope :hidden, -> { where('people.hidden_at IS NOT NULL AND (people.unhidden_at IS NULL OR people.unhidden_at < people.hidden_at)') }

  after_initialize :initialize_profile
  before_validation :calculate_sorting_name
  after_save :refresh_party_councillors_count
  after_destroy :refresh_party_councillors_count

  def not_working?
    leaving_date.present?
  end

  def profile
    write_attribute(:profile, {}) if read_attribute(:profile).nil?
    read_attribute(:profile)
  end

  def councillor?
    job_level == 'councillor'
  end

  def director?
    job_level == 'director'
  end

  def temporary_worker?
    job_level == 'temporary_worker'
  end

  def studies
    parse_data_rows(profile, :studies)
  end

  def studies_attributes=(attributes)
    profile['studies'] = clean_attributes attributes
  end

  def studies_comment
    profile['studies_comment']
  end

  def studies_comment=(comment)
    profile['studies_comment'] = comment
  end

  def has_studies?
    profile['studies'].present? || profile['studies_comment'].present?
  end

  def has_courses?
    profile['courses'].present? || profile['courses_comment'].present?
  end

  def courses
    parse_data_rows(profile, :courses)
  end

  def courses_attributes=(attributes)
    profile['courses'] = clean_attributes attributes
  end

  def courses_comment
    profile['courses_comment']
  end

  def courses_comment=(comment)
    profile['courses_comment'] = comment
  end

  def languages
    parse_data_rows(profile, :languages)
  end

  def languages_attributes=(attributes)
    profile['languages']= clean_attributes attributes
  end

  def public_jobs
    parse_data_rows(profile, :public_jobs)
  end

  def public_jobs_attributes=(attributes)
    profile['public_jobs']= clean_attributes attributes
  end

  def private_jobs
    parse_data_rows(profile, :private_jobs)
  end

  def private_jobs_attributes=(attributes)
    profile['private_jobs'] = clean_attributes attributes
  end

  def has_career?
    profile['public_jobs'].try(:any?) ||
    profile['private_jobs'].try(:any?) ||
    profile['public_posts'].try(:any?) ||
    career_comment.present? ||
    public_jobs_level.present? ||
    public_jobs_body.present? ||
    public_jobs_start_year.present?
  end

  def career_comment
    profile['career_comment']
  end

  def career_comment=(comment)
    profile['career_comment']= comment
  end

  def public_jobs_level
    profile['public_jobs_level']
  end

  def public_jobs_level=(level)
    profile['public_jobs_level']= level
  end

  def public_jobs_body
    profile['public_jobs_body']
  end

  def public_jobs_body=(body)
    profile['public_jobs_body']= body
  end

  def public_jobs_start_year
    profile['public_jobs_start_year']
  end

  def public_jobs_start_year=(start_year)
    profile['public_jobs_start_year']= start_year
  end

  def political_posts
    parse_data_rows(profile, :political_posts)
  end

  def political_posts_attributes=(attributes)
    profile['political_posts']= clean_attributes attributes
  end

  def political_posts_comment
    profile['political_posts_comment']
  end

  def political_posts_comment=(comment)
    profile['political_posts_comment']= comment
  end

  def publications
    profile['publications']
  end

  def publications=(pub)
    profile['publications']=pub
  end

  def special_mentions
    profile['special_mentions']
  end

  def special_mentions=(mentions)
    profile['special_mentions']= mentions
  end

  def teaching_activity
    profile['teaching_activity']
  end

  def teaching_activity=(activity)
    profile['teaching_activity']=activity
  end

  def other
    profile['other']
  end

  def other=(o)
    profile['other']= o
  end

  def add_study(description, entity, start_year, end_year)
    add_item('studies', description, entity, start_year, end_year)
  end

  def add_course(description, entity, start_year, end_year)
    add_item('courses', description, entity, start_year, end_year)
  end

  def add_language(name, level)
    return unless name.present?
    self.profile['languages'] ||= []
    self.profile['languages'] << { name: name, level: level }
  end

  def add_public_job(description, entity, start_year, end_year)
    add_item('public_jobs', description, entity, start_year, end_year)
  end

  def add_private_job(description, entity, start_year, end_year)
    add_item('private_jobs', description, entity, start_year, end_year)
  end

  def add_political_post(description, entity, start_year, end_year)
    add_item('political_posts', description, entity, start_year, end_year)
  end

  # Regenerate slug if name changes
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def party_name
    party.try(:name) || I18n.t('people.no_party')
  end

  def name_initial
    ActiveSupport::Inflector.transliterate(self.last_name[0]).upcase
  end

  def area
    super || I18n.t('people.no_area')
  end

  def name
    "#{first_name} #{last_name}"
  end

  def backwards_name
    "#{last_name}, #{first_name}"
  end

  def name_changed?
    first_name_changed? || last_name_changed?
  end

  def self.grouped_by_name_initial
    order(:sorting_name)
      .group_by(&:name_initial)
      .sort.to_h
  end

  def self.grouped_by_party
    sorted_party_ids = Party.all.order(councillors_count: :desc).pluck(:id)
    Hash[self.includes(:party)
             .order(leaving_date: :desc, councillor_order: :asc)
             .group_by(&:party)
             .sort_by{|party, v| sorted_party_ids.index(party.id)}
    ]
  end

  def hide(hidden_by, hidden_reason)
    self.update(hidden_at: DateTime.current,
                hidden_by_id: hidden_by.id,
                hidden_reason: hidden_reason)
  end

  def unhide(unhidden_by, unhidden_reason)
    self.update(unhidden_at: DateTime.current,
                unhidden_by_id: unhidden_by.id,
                unhidden_reason: unhidden_reason)
  end

  def hidden?
    hidden_at.present? && (unhidden_at.blank? || unhidden_at < hidden_at)
  end

  def unhidden?
    hidden_at.blank? || (unhidden_at.present? && unhidden_at > hidden_at)
  end

  private

    def initialize_profile
      self.profile ||= {}
    end

    def add_item(collection, description, entity, start_year, end_year)
      return unless description.present?
      self.profile[collection] ||= []
      self.profile[collection] << {description: description, entity: entity, start_year: start_year, end_year: end_year}
    end

    def clean_attributes(attributes)
      attributes.values.select{ |a| a.values.any?(&:present?) }
    end

    def calculate_sorting_name
      self.sorting_name = SortingNameCalculator.calculate(first_name, last_name)
    end

    def refresh_party_councillors_count
      if party.present?
        party.refresh_councillors_count
      end
    end

end
