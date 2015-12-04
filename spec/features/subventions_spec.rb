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

  scenario 'Sort ascending and descending' do
    create(:subvention, recipient: 'Naturalis')
    create(:subvention, recipient: 'Children of the green')
    create(:subvention, recipient: 'GreenCross')

    visit subventions_path

    click_link 'Recipient'

    expect('Children of the green').to appear_before('GreenCross')
    expect('GreenCross').to appear_before('Naturalis')

    click_link 'Recipient'

    expect('Naturalis').to appear_before('GreenCross')
    expect('GreenCross').to appear_before('Children of the green')
  end

end