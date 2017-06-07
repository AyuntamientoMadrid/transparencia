class Objective < ActiveRecord::Base
  belongs_to :department

  validates :title, :description, presence: true

  scope :accomplished, ->     { where(accomplished: true) }
  scope :not_accomplished, -> { where(accomplished: false) }  

end