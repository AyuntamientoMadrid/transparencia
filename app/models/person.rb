class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :party

  has_many :assets_declarations, dependent: :destroy
  has_many :activities_declarations, dependent: :destroy

  validates :name,   presence: true
  validates :email,  presence: true
  validates :role,   presence: true

  scope :sorted_for_display, -> { includes(:party).order('parties.name', :internal_code) }
end
