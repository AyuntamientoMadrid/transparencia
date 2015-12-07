class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  include ParseDataRows

  belongs_to :party

  has_many :assets_declarations, dependent: :destroy
  has_many :activities_declarations, dependent: :destroy

  validates :name,   presence: true
  validates :role,   presence: true

  scope :sorted_for_display, -> { order(:councillor_code) }

  def profile
    read_attribute(:profile) || {}
  end

  def studies
    parse_data_rows(profile, :studies)
  end

  def studies_comment
    profile['studies_comment']
  end

  def courses
    parse_data_rows(profile, :courses)
  end

  def languages
    parse_data_rows(profile, :languages)
  end

  def courses_comment
    profile['courses_comment']
  end

  def public_jobs
    parse_data_rows(profile, :public_jobs)
  end

  def public_jobs_comment
    profile['public_jobs_comment']
  end

  def private_jobs
    parse_data_rows(profile, :private_jobs)
  end

  def private_jobs_comment
    profile['private_jobs_comment']
  end

  def political_posts
    parse_data_rows(profile, :political_posts)
  end

  def political_posts_comment
    profile['political_posts_comment']
  end

  def publications
    profile['publications']
  end

  def special_mentions
    profile['special_mentions']
  end

  def activity
    profile['activity']
  end

  def other
    profile['other']
  end


end
