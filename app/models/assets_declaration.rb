class AssetsDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person, touch: true

  validates :declaration_date, presence: true

  def real_estate_properties
    parse_data_rows('real_estate_properties')
  end

  def account_deposits
    parse_data_rows('account_deposits')
  end

  def other_deposits
    parse_data_rows('other_deposits')
  end

  def vehicles
    parse_data_rows('vehicles')
  end

  def other_personal_properties
    parse_data_rows('other_personal_properties')
  end

  def debts
    parse_data_rows('debts')
  end

  def add_real_estate_property(kind, type, description, municipality, share, purchase_date, tax_value)
    self.data ||= {}
    self.data['real_estate_properties'] ||= []
    self.data['real_estate_properties'] << {
      'kind' => kind,
      'type' => type,
      'description' => description,
      'municipality' => municipality,
      'share' => share,
      'purchase_date' => purchase_date,
      'tax_value' => tax_value
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
    self.data['other_deposits'] << {'kind' => kind, 'description' => description, 'amount' => amount, 'purchase_date' => purchase_date }
  end

  def add_vehicle(kind, model, purchase_date)
    self.data ||= {}
    self.data['vehicles'] ||= []
    self.data['vehicles'] << {'kind' => kind, 'model' => model, 'purchase_date' => purchase_date}
  end

  def add_other_personal_property(kind, purchase_date)
    self.data ||= {}
    self.data['other_personal_properties'] ||= []
    self.data['other_personal_properties'] << {'kind' => kind, 'purchase_date' => purchase_date}
  end

  def add_debt(kind, amount, comments)
    self.data ||= {}
    self.data['debts'] ||= []
    self.data['debts'] << {'kind' => kind, 'amount' => amount, 'comments' => comments}
  end

end
