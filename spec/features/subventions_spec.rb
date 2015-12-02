require 'rails_helper'

feature 'Subventions' do

  scenario 'Index' do
    subventions = [create(:subvention),
                   create(:subvention, project: "Green", year: "2017", location: "Malmö")]
    visit subventions_path

    subventions.each do |subvention|
      expect(page).to have_content(subvention.recipient)
      expect(page).to have_content(subvention.project)
      expect(page).to have_content(subvention.year)
      expect(page).to have_content(subvention.location)
      expect(page).to have_content(subvention.amount_euro_cents)
    end
  end

end