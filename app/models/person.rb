class Person < ActiveRecord::Base

  belongs_to :party

  has_many :assets_declarations
  has_many :activities_declarations

  validates :name,   presence: true
  validates :email,  presence: true
  validates :role,   presence: true

end
