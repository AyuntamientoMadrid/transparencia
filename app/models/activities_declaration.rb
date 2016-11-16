class ActivitiesDeclaration < ActiveRecord::Base

  include ParseDataRows

  scope :for_year, -> (year) { where ["declaration_date >= ? and declaration_date <= ?", Date.new(year,1,1), Date.new(year,12,31)] }
  scope :for_period, -> (period) { where(period: period) }
  scope :sort_for_list, -> { order("(CASE WHEN period = 'initial' THEN 0 WHEN period = 'final' THEN 2 ELSE 1 END) ASC, declaration_date ASC") }

  belongs_to :person, touch: true

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

  def add_other_activity(description, start_date, end_date)
    self.data ||= {}
    self.data['other_activities'] ||= []
    self.data['other_activities'] << {
      'description' => description,
      'start_date' => start_date,
      'end_date' => end_date
    }
  end

end
