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

  scenario 'Search' do
    create(:contract, description: 'Build a park')
    create(:contract, description: 'Build a hospital')
    create(:contract, description: 'Clean the streets')

    visit contracts_path

    fill_in :query, with: 'build'
    click_button 'Search'

    expect(page).to have_content("2 results found")
    expect(page).to have_content("Build a park")
    expect(page).to have_content("Build a hospital")
  end

  scenario 'Sort ascending and descending' do
    create(:contract, recipient: 'Johnson and Smithers')
    create(:contract, recipient: 'Building the world')
    create(:contract, recipient: 'Keeping you healthy')

    visit contracts_path

    click_link 'Recipient'

    expect('Building the world').to appear_before('Johnson and Smithers')
    expect('Johnson and Smithers').to appear_before('Keeping you healthy')

    click_link 'Recipient'

    expect('Keeping you healthy').to appear_before('Johnson and Smithers')
    expect('Johnson and Smithers').to appear_before('Building the world')
  end

  scenario 'Show' do
    subvention = create(:subvention, project: "Green", year: "2017", location: "Malmö", amount_cents: 987654321)
    visit subvention_path(subvention)

    expect(page).to have_content(subvention.recipient)
    expect(page).to have_content(subvention.project)
    expect(page).to have_content(subvention.year)
    expect(page).to have_content(subvention.location)
    expect(page).to have_content(number_to_currency(subvention.amount_cents/100.0))
  end

  context 'Admin actions' do
    background do
      login_as create(:administrator)
    end

    scenario 'Create' do
      visit new_contract_path
      fill_in :contract_recipient, with: "NBA"
      fill_in :contract_description, with: "New basketball court in Berlin park"
      fill_in :contract_award_amount_cents, with: "12345678"
      fill_in :contract_center, with: "Town Hall"
      fill_in :contract_organism, with: "Parks department"
      fill_in :contract_contract_number, with: "33LB"
      fill_in :contract_document_number, with: "32KMcH"
      fill_in :contract_recipient_document_number, with: "00RB"
      fill_in :contract_kind, with: "Good"
      fill_in :contract_award_procedure, with: "Lotery"
      fill_in :contract_article, with: "123A"
      fill_in :contract_article_section, with: "XYZ1"
      fill_in :contract_award_criteria, with: "FIFO"
      fill_in :contract_budget_amount_cents, with: "99999999"
      fill_in :contract_term, with: "AA"
      select '2020', from: :contract_awarded_at_1i
      select 'December',   from: :contract_awarded_at_2i
      select '1',    from: :contract_awarded_at_3i
      select '2017', from: :contract_formalized_at_1i
      select 'April',    from: :contract_formalized_at_2i
      select '3',    from: :contract_formalized_at_3i
      check :contract_framework_agreement
      check :contract_zero_cost_revenue

      click_button "Save"

      visit contracts_path
      expect(page).to have_content "NBA"

      contract = Contract.last
      visit contract_path(contract)
      expect(page).to have_content "NBA"
      expect(page).to have_content "New basketball court in Berlin park"
      expect(page).to have_content "Town Hall"
      expect(page).to have_content "Parks department"
      expect(page).to have_content "33LB"
      expect(page).to have_content "32KMcH"
      expect(page).to have_content "00RB"
      expect(page).to have_content "Good"
      expect(page).to have_content "Lotery"
      expect(page).to have_content "123A"
      expect(page).to have_content "XYZ1"
      expect(page).to have_content "FIFO"
      expect(page).to have_content "AA"
      expect(page).to have_content "Framework agreement"
      expect(page).to have_content "Zero cost revenue"
      expect(page).to have_content "December 01, 2020"
      expect(page).to have_content "April 03, 2017"
      expect(page).to have_content number_to_currency(123456.78)
      expect(page).to have_content number_to_currency(999999.99)
    end

    scenario 'Update' do
      contract = create(:contract, description: "Show me what you got", zero_cost_revenue: true)

      visit contract_path(contract)
      click_on "Edit"

      fill_in :contract_description, with: "Get Swchifty"
      uncheck :contract_zero_cost_revenue
      check :contract_framework_agreement
      click_button "Save"

      visit contracts_path
      expect(page).to have_content "Get Swchifty"
      expect(page).not_to have_content "Show me what you got"

      visit contract_path(contract)
      expect(page).to have_content(contract.recipient)
      expect(page).to have_content("Get Swchifty")
      expect(page).to have_content(contract.center)
      expect(page).to have_content(contract.organism)
      expect(page).to have_content "Framework agreement"
      expect(page).to_not have_content "Zero cost revenue"
      expect(page).to have_content(number_to_currency(contract.award_amount_cents/100.0))
    end

    scenario 'Delete' do
      contract = create(:contract, description: "Blue skies")

      visit contracts_path
      expect(page).to have_content "Blue skies"

      visit contract_path(contract)
      click_on "Delete"

      visit contracts_path
      expect(page).to_not have_content "Blue skies"
    end
  end

end