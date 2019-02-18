require 'sorting_name_calculator'

class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  include ParseDataRows

  self.record_timestamps = false

  has_attached_file :portrait,
                    styles: { medium: "300x300>", thumb: "100x100>" },
                    url: "/people/:friendly.jpg",
                    use_timestamp: false
  validates_attachment_content_type :portrait, content_type: %r{\Aimage\/.*\z}

  Paperclip.interpolates :friendly do |attachment, style|
    attachment.instance.friendly_id
  end

  belongs_to :party
  belongs_to :hidden_by,   class_name: 'Administrator'
  belongs_to :unhidden_by, class_name: 'Administrator'

  has_many :assets_declarations,     -> { sort_for_list }, dependent: :destroy
  has_many :activities_declarations, -> { sort_for_list }, dependent: :destroy

  accepts_nested_attributes_for :activities_declarations
  accepts_nested_attributes_for :assets_declarations

  scope :unhidden, -> { where('people.hidden_at IS NULL OR (people.unhidden_at IS NOT NULL AND people.unhidden_at > people.hidden_at)') }
  scope :hidden,   -> { where('people.hidden_at IS NOT NULL AND (people.unhidden_at IS NULL OR people.unhidden_at < people.hidden_at)') }

  def self.job_levels
    %W{councillor director temporary_worker public_worker spokesperson labour}
  end

  def self.orders
    %w{party_name area name_initial}
  end

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :role,       presence: true
  validates :job_level,  presence: true
  validates :party,      presence: true, if: :councillor?
  validates :job_level,  inclusion: { in: Person.job_levels }

  scope :councillors,       -> { where(job_level: 'councillor') }
  scope :directors,         -> { where(job_level: 'director') }
  scope :temporary_workers, -> { where(job_level: 'temporary_worker') }
  scope :public_workers,    -> { where(job_level: 'public_worker') }
  scope :spokespeople,      -> { where(job_level: 'spokesperson') }
  scope :labours,           -> { where(job_level: 'labour') }
  scope :working,           -> { where(leaving_date: nil) }
  scope :not_working,       -> { where.not(leaving_date: nil).order(:leaving_date) }

  scope :unhidden, -> { where('people.hidden_at IS NULL OR (people.unhidden_at IS NOT NULL AND people.unhidden_at > people.hidden_at)') }
  scope :hidden,   -> { where('people.hidden_at IS NOT NULL AND (people.unhidden_at IS NULL OR people.unhidden_at < people.hidden_at)') }

  after_initialize :initialize_profile
  before_validation :calculate_sorting_name
  after_save :refresh_party_councillors_count
  after_destroy :refresh_party_councillors_count

  def not_working?
    !working?
  end

  def working?
    leaving_date.blank?
  end

  def profile
    self[:profile] = {} if self[:profile].nil?
    self[:profile]
  end

  def should_display_profile?
    # non-working councillors should not display their profile
    !councillor? || working?
  end

  def should_display_declarations?
    councillor? || director?
  end

  def should_display_calendar?
    working?
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

  def public_worker?
    job_level == 'public_worker'
  end

  def spokesperson?
    job_level == 'spokesperson'
  end

  def labour?
    job_level == 'labour'
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
    profile['languages'] = clean_attributes attributes
  end

  def public_jobs
    parse_data_rows(profile, :public_jobs)
  end

  def public_jobs_attributes=(attributes)
    profile['public_jobs'] = clean_attributes attributes
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
    profile['career_comment'] = comment
  end

  def public_jobs_level
    profile['public_jobs_level']
  end

  def public_jobs_level=(level)
    profile['public_jobs_level'] = level
  end

  def public_jobs_body
    profile['public_jobs_body']
  end

  def public_jobs_body=(body)
    profile['public_jobs_body'] = body
  end

  def public_jobs_start_year
    profile['public_jobs_start_year']
  end

  def public_jobs_start_year=(start_year)
    profile['public_jobs_start_year'] = start_year
  end

  def political_posts
    parse_data_rows(profile, :political_posts)
  end

  def political_posts_attributes=(attributes)
    profile['political_posts'] = clean_attributes attributes
  end

  def political_posts_comment
    profile['political_posts_comment']
  end

  def political_posts_comment=(comment)
    profile['political_posts_comment'] = comment
  end

  def publications
    profile['publications']
  end

  def publications=(pub)
    profile['publications'] = pub
  end

  def special_mentions
    profile['special_mentions']
  end

  def special_mentions=(mentions)
    profile['special_mentions'] = mentions
  end

  def teaching_activity
    profile['teaching_activity']
  end

  def teaching_activity=(activity)
    profile['teaching_activity'] = activity
  end

  def other
    profile['other']
  end

  def other=(o)
    profile['other'] = o
  end

  def add_study(description, entity, start_year, end_year)
    add_item('studies', description, entity, start_year, end_year)
  end

  def add_course(description, entity, start_year, end_year)
    add_item('courses', description, entity, start_year, end_year)
  end

  def add_language(name, level)
    return if name.blank?
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
    sorting_name[0].upcase
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
      .map { |k, v| [k, v.sort_by(&:sorting_name)] }
      .to_h
  end

  def self.grouped_by_party
    sorted_party_ids = Party.all.order(councillors_count: :desc).pluck(:id)
    Hash[self.includes(:party)
             .order(leaving_date: :desc, councillor_order: :asc)
             .group_by(&:party)
             .sort_by{ |party, v| sorted_party_ids.index(party.id) }
    ]
  end

  def hide(hidden_by, hidden_reason, hidden_at = DateTime.current)
    attrs = { unhidden_at: nil,
              unhidden_by_id: nil,
              hidden_at: hidden_at,
              unhidden_reason: nil,
              hidden_by_id: hidden_by.id,
              hidden_reason: hidden_reason }
    attrs[:leaving_date] = hidden_at if councillor?
    self.update(attrs)
  end

  def unhide(unhidden_by, unhidden_reason, unhidden_at = DateTime.current)
    self.update(hidden_at: nil,
                hidden_by_id: nil,
                leaving_date: nil,
                unhidden_at: unhidden_at,
                unhidden_by_id: unhidden_by.id,
                unhidden_reason: unhidden_reason)
  end

  def hidden?
    hidden_at.present? && (unhidden_at.blank? || unhidden_at < hidden_at)
  end

  def unhidden?
    hidden_at.blank? || (unhidden_at.present? && unhidden_at > hidden_at)
  end

  %i(first second third fourth).each_with_index do |ordinal, index|
    %i(description entity start_year end_year).each do |field|
      define_method "#{ordinal}_study_#{field}" do
        studies[index].try(field)
      end

      define_method "#{ordinal}_course_#{field}" do
        courses[index].try(field)
      end

      define_method "#{ordinal}_public_job_#{field}" do
        public_jobs[index].try(field)
      end

      define_method "#{ordinal}_private_job_#{field}" do
        private_jobs[index].try(field)
      end

      define_method "#{ordinal}_political_post_#{field}" do
        political_posts[index].try(field)
      end
    end
  end

  { english: 'Inglés', french: 'Francés',
    german: 'Alemán', italian: 'Italiano' }.each do |symbol, name|
    define_method "language_#{symbol}_level" do
      languages.find { |l| l[:name].to_s == name }.try(:[], :level)
    end
  end

  def language_other_name
    languages.find { |l| !%w(Inglés Francés Alemán Italiano).include?(l.name) }.try(:name)
  end

  def language_other_level
    languages.find { |l| !%w(Inglés Francés Alemán Italiano).include?(l.name) }.try(:level)
  end

  def job_level_code
    return 'C' if councillor?
    return 'D' if director?
    return 'E' if temporary_worker?
    return 'F' if public_worker?
    return 'L' if labour?
    return 'V' if spokesperson?
  end

  private

    def initialize_profile
      self.profile ||= {}
    end

    def add_item(collection, description, entity, start_year, end_year)
      return if description.blank?
      self.profile[collection] ||= []
      self.profile[collection] << { description: description, entity: entity, start_year: start_year, end_year: end_year }
    end

    def clean_attributes(attributes)
      attributes.values.select{ |a| a.values.any?(&:present?) }
    end

    def calculate_sorting_name
      self.sorting_name = SortingNameCalculator.calculate(first_name, last_name)
    end

    def refresh_party_councillors_count
      party.refresh_councillors_count if party.present?
    end

end
