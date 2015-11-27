class ActivitiesDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person

  validates :declaration_date, presence: true

  def public_activities
    parse_data_rows('public_activities')
  end

  def private_activities
    parse_data_rows('private_activities')
  end

  def other_activities
    parse_data_rows('other_activities')
  end

  def has_public_activity?(entity, position, start_date, end_date)
    public_activities.any? do |activity|
      activity.entity == entity &&
      activity.position == position &&
      activity.start_date == start_date &&
      activity.end_date == end_date
    end
  end

  def add_public_activity(entity, position, start_date, end_date)
    self.data ||= {}
    self.data['public_activities'] ||= []
    self.data['public_activities'] << {
      'entity' => entity,
      'position' => position,
      'start_date' => start_date,
      'end_date' => end_date
    }
  end

end
