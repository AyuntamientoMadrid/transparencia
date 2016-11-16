class Party < ActiveRecord::Base

  validates :name, presence: true
  validates :logo, presence: true

  has_many :councillors, -> { councillors }, class_name: 'Person'

  def refresh_councillors_count
    update(councillors_count: self.councillors.count)
  end

end
