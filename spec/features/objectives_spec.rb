require 'rails_helper'

feature 'Objectives' do
  scenario 'Show' do
    objective = create(:objective)
    
    visit objective_path

    within first('.objective') do
      expect(page).to have_content objective.title
      # more expects...
    end
  end
end