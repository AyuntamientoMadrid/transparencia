class ActivitiesDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person

  validates :declaration_date, presence: true

  def public_activities
    parse_data_rows(data, :public_activities)
  end

  def private_activities
    parse_data_rows(data, :private_activities)
  end

  def other_activities
    parse_data_rows(data, :other_activities)
  end

end
