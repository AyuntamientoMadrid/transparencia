class Person < ActiveRecord::Base

  belongs_to :party

  has_many :assets_declarations
  has_one  :most_recent_assets_declaration, ->{ order('start_date DESC') }, class_name: "AssetsDeclaration"

  has_many :activities_declarations
  has_one  :most_recent_activities_declaration, ->{ order('start_date DESC') }, class_name: "ActivitiesDeclaration"

  validates :name,   presence: true
  validates :email,  presence: true
  validates :gender, presence: true
  validates :role,   presence: true

end
