require 'rails_helper'

feature 'Contracts' do

  scenario 'Index' do
    contracts = [create(:contract),
                 create(:contract, recipient: "Smither", description: 'Build a hospital', organism: 'Health', awarded_at: 1.month.ago, award_amount_cents: 91823721)]

    visit contracts_path

    contracts.each do |contract|
      expect(page).to have_content(contract.recipient)
      expect(page).to have_content(contract.description)
      expect(page).to have_content(contract.organism)
      expect(page).to have_content(I18n.l contract.awarded_at, format: :long)
      expect(page).to have_content(number_to_currency(contract.award_amount_cents/100.0))
    end
  end

end