class Objective < ActiveRecord::Base
  belongs_to :department

  validates_presence_of :title, :description

  scope :accomplished, ->     { where(accomplished: true) }
  scope :not_accomplished, -> { where(accomplished: false) }  

end