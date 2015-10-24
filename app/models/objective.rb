class Objective < ActiveRecord::Base
  belongs_to :department

  validates_presence_of :title, :description
end