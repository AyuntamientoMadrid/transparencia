class Party < ActiveRecord::Base

  validates :name, presence: true
  validates :logo, presence: true

end
