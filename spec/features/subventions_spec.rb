require 'rails_helper'

feature 'Subventions' do

  scenario 'Index' do
    subventions = [create(:subvention),
                   create(:subvention, project: "Green", year: "2017", location: "Malmö", amount_euro_cents: 987654321)]
    visit subventions_path

    subventions.each do |subvention|
      expect(page).to have_content(subvention.recipient)
      expect(page).to have_content(subvention.project)
      expect(page).to have_content(subvention.year)
      expect(page).to have_content(subvention.location)
      expect(page).to have_content(number_to_currency(subvention.amount_euro_cents/100.0))
    end
  end

  scenario 'Search' do
    create(:subvention, project: 'Clean the parks')
    create(:subvention, project: 'Save the children')
    create(:subvention, project: 'Educate the children')

    visit subventions_path

    fill_in :query, with: 'children'
    click_button 'Search'

    expect(page).to have_content("2 results found")
    expect(page).to have_content("Save the children")
    expect(page).to have_content("Educate the children")
  end

  scenario 'Show' do
    subvention = create(:subvention, project: "Green", year: "2017", location: "Malmö", amount_euro_cents: 987654321)
    visit subvention_path(subvention)

    expect(page).to have_content(subvention.recipient)
    expect(page).to have_content(subvention.project)
    expect(page).to have_content(subvention.year)
    expect(page).to have_content(subvention.location)
    expect(page).to have_content(number_to_currency(subvention.amount_euro_cents/100.0))
  end

  context 'Admin actions' do
    background do
      login_as create(:administrator)
    end

    scenario 'Create' do
      visit new_subvention_path
      fill_in :subvention_recipient, with: "Green Amnesty"
      fill_in :subvention_project, with: "New forest"
      fill_in :subvention_amount_euro_cents, with: "12345678"
      fill_in :subvention_kind, with: "Ecology"
      fill_in :subvention_location, with: "Antarctica"
      fill_in :subvention_year, with: "2020"
      click_button "Save"

      visit subventions_path
      expect(page).to have_content "Green Amnesty"

      subvention = Subvention.last
      visit subvention_path(subvention)
      expect(page).to have_content "Green Amnesty"
      expect(page).to have_content "New forest"
      expect(page).to have_content "Ecology"
      expect(page).to have_content "Antarctica"
      expect(page).to have_content "2020"
      expect(page).to have_content number_to_currency(123456.78)
    end

    scenario 'Update' do
      subvention = create(:subvention, project: "Kill whales")

      visit subvention_path(subvention)
      click_on "Edit"

      fill_in :subvention_project, with: "Blue sea"
      click_button "Save"

      visit subventions_path
      expect(page).to have_content "Blue sea"
      expect(page).not_to have_content "Kill whales"

      visit subvention_path(subvention)
      expect(page).to have_content(subvention.recipient)
      expect(page).to have_content("Blue sea")
      expect(page).to have_content(subvention.year)
      expect(page).to have_content(subvention.location)
      expect(page).to have_content(number_to_currency(subvention.amount_euro_cents/100.0))
    end

    scenario 'Delete' do
      subvention = create(:subvention, project: "Blue sky")

      visit subventions_path
      expect(page).to have_content "Blue sky"

      visit subvention_path(subvention)
      click_on "Delete"

      visit subventions_path
      expect(page).to_not have_content "Blue sky"
    end
  end

end