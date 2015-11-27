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

  def has_private_activity?(kind, description, entity, position, start_date, end_date)
    private_activities.any? do |activity|
      activity.kind == kind &&
      activity.description == description &&
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

  def add_private_activity(kind, description, entity, position, start_date, end_date)
    self.data ||= {}
    self.data['private_activities'] ||= []
    self.data['private_activities'] << {
      'kind' => kind,
      'description' => description,
      'entity' => entity,
      'position' => position,
      'start_date' => start_date,
      'end_date' => end_date
    }
  end

end
