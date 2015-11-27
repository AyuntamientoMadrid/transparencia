class AssetsDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person

  validates :declaration_date, presence: true

  def real_estate_properties
    parse_data_rows('real_estate_properties')
  end

  def account_deposits
    parse_data_rows('account_deposits')
  end

  def other_assets
    parse_data_rows('other_assets')
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

  def add_account_deposit(kind, banking_entity, balance)
    self.data ||= {}
    self.data['account_deposits'] ||= []
    self.data['account_deposits'] << {'kind' => kind, 'banking_entity' => banking_entity, 'balance' => balance }
  end

  def has_account_deposit?(kind, banking_entity, balance)
    account_deposits.any? do |deposit|
      deposit.kind == kind &&
      deposit.banking_entity == banking_entity &&
      deposit.balance == balance
    end
  end

end
