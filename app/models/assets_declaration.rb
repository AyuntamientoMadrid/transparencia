class AssetsDeclaration < ActiveRecord::Base
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

  def real_estate_properties
    parse_data_rows(data, :real_estate_properties)
  end

  def account_deposits
    parse_data_rows(data, :account_deposits)
  end

  def other_deposits
    parse_data_rows(data, :other_deposits)
  end

  def vehicles
    parse_data_rows(data, :vehicles)
  end

  def other_personal_properties
    parse_data_rows(data, :other_personal_properties)
  end

  def debts
    parse_data_rows(data, :debts)
  end

  def tax_data
    parse_data_rows(data, :tax_data)
  end

  def real_estate_properties_attributes=(attributes)
    initialize_data
    data['real_estate_properties'] = clean_attributes attributes
  end

  def add_real_estate_property(kind, type, description, municipality, share, purchase_date, tax_value, notes)
    self.data ||= {}
    self.data['real_estate_properties'] ||= []
    self.data['real_estate_properties'] << {
      'kind' => kind,
      'type' => type,
      'description' => description,
      'municipality' => municipality,
      'share' => share,
      'purchase_date' => parse_date(purchase_date),
      'tax_value' => tax_value,
      'notes' => notes
    }
  end

  def add_account_deposit(kind, banking_entity, balance)
    self.data ||= {}
    self.data['account_deposits'] ||= []
    self.data['account_deposits'] << {'kind' => kind, 'banking_entity' => banking_entity, 'balance' => balance }
  end

  def add_other_deposit(kind, description, amount, purchase_date)
    self.data ||= {}
    self.data['other_deposits'] ||= []
    self.data['other_deposits'] << {'kind' => kind, 'description' => description, 'amount' => amount, 'purchase_date' => parse_date(purchase_date) }
  end

  def add_vehicle(kind, model, purchase_date)
    self.data ||= {}
    self.data['vehicles'] ||= []
    self.data['vehicles'] << {'kind' => kind, 'model' => model, 'purchase_date' => parse_date(purchase_date)}
  end

  def add_other_personal_property(kind, purchase_date)
    self.data ||= {}
    self.data['other_personal_properties'] ||= []
    self.data['other_personal_properties'] << {'kind' => kind, 'purchase_date' => parse_date(purchase_date)}
  end

  def add_debt(kind, amount, comments)
    self.data ||= {}
    self.data['debts'] ||= []
    self.data['debts'] << {'kind' => kind, 'amount' => amount, 'comments' => comments}
  end

  def add_tax_data(tax, fiscal_data, amount, comments)
    self.data ||= {}
    self.data['tax_data'] ||= []
    self.data['tax_data'] << {'tax' => tax, 'fiscal_data' => fiscal_data, 'amount' => amount, 'comments' => comments}
  end

  def complete_values
    local_attributes = attributes.delete_if{ |k,_| ['id', 'person_id'].include? k }
    local_attributes.values.map{|val| val.is_a?(Hash) ? val.values.flatten.map(&:values) : val}.flatten
  end

  def account_deposits_attributes=(attributes)
    data['account_deposits'] = clean_attributes attributes
  end

  def other_deposits_attributes=(attributes)
    data['other_deposits'] = clean_attributes attributes
  end

  def vehicles_attributes=(attributes)
    data['vehicles'] = clean_attributes attributes
  end

  def other_personal_properties_attributes=(attributes)
    data['other_personal_properties'] = clean_attributes attributes
  end

  def debts_attributes=(attributes)
    data['debts'] = clean_attributes attributes
  end

  def tax_data_attributes=(attributes)
    data['tax_data'] = clean_attributes attributes
  end

  private

    def initialize_data
      self.data ||= {"real_estate_properties" => []}
    end

    def clean_attributes(attributes)
      attributes.values.select{ |a| a.values.any?(&:present?) }
    end

    def deep_data_declaration_date
      return unless declaration_date.blank? && complete_values.compact.map(&:blank?).include?(false)
      errors.add(:declaration_date, t("errors.messages.blank"))
    end

end
