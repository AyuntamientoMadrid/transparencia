class ActivitiesDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person

  validates :start_date, presence: true

  def public_activities
    parse_data_rows('public_activities')
  end

  def private_activities
    parse_data_rows('private_activities')
  end

  def other_activities
    parse_data_rows('other_activities')
  end

end
