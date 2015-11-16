class AssetsDeclaration < ActiveRecord::Base

  include ParseDataRows

  belongs_to :person

  validates :start_date, presence: true

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

end
