class ActivitiesDeclaration < ActiveRecord::Base
  include DateHelper
  include ParseDataRows

  scope :for_year, -> (year) { where ["declaration_date >= ? and declaration_date <= ?", Date.new(year,1,1), Date.new(year,12,31)] }
  scope :for_period, -> (period) { where(period: period) }
  scope :sort_for_list, -> { order("(CASE WHEN period = 'initial' THEN 0 WHEN period = 'final' THEN 2 ELSE 1 END) ASC, declaration_date ASC") }

  belongs_to :person, touch: true

  validates :declaration_date, presence: true

  def initial?
    %w[initial inicial].include?(period.downcase)
  end

  def final?
    period == 'final'
  end

  def public_activities
    parse_data_rows(data, :public_activities)
  end

  def public_activities_attributes=(attributes)
    initialize_data
    data['public_activities'] = clean_attributes attributes
  end

  def private_activities
    parse_data_rows(data, :private_activities)
  end

  def private_activities_attributes=(attributes)
    initialize_data
    data['private_activities'] = clean_attributes attributes
  end

  def other_activities
    parse_data_rows(data, :other_activities)
  end

  def other_activities_attributes=(attributes)
    initialize_data
    data['other_activities'] = clean_attributes attributes
  end

  def add_public_activity(entity, position, start_date, end_date)
    self.data ||= {}
    self.data['public_activities'] ||= []
    self.data['public_activities'] << {
      'entity' => entity,
      'position' => position,
      'start_date' => parse_date(start_date),
      'end_date' => parse_date(end_date)
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
      'start_date' => parse_date(start_date),
      'end_date' => parse_date(end_date)
    }
  end

  def add_other_activity(description, start_date, end_date)
    self.data ||= {}
    self.data['other_activities'] ||= []
    self.data['other_activities'] << {
      'description' => description,
      'start_date' => parse_date(start_date),
      'end_date' => parse_date(end_date)
    }
  end

  def complete_values
    local_attributes = attributes.delete_if{ |k,_| ['id', 'person_id'].include? k }
    local_attributes.values.map{|val| val.is_a?(Hash) ? val.values.flatten.map(&:values) : val}.flatten
  end

  private

    def initialize_data
      self.data ||= {"public_activities" => [],
                     "private_activities" => [],
                     "other_activities" => []}
    end

    def clean_attributes(attributes)
      attributes.values.select{ |a| a.values.any?(&:present?) }
    end

    def deep_data_declaration_date
      return unless declaration_date.blank? && complete_values.compact.map(&:blank?).include?(false)
      errors.add(:declaration_date, t("errors.messages.blank"))
    end

end