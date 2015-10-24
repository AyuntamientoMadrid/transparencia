require 'rails_helper'

feature 'Objectives' do

  let!(:area)        { create(:area) }
  let!(:department)  { create(:department, area: area) }
  let!(:objective)   { create(:objective, department: department) }

  scenario 'Show' do

    visit objective_path(objective)

    expect(page).to have_content objective.department.area.name
    expect(page).to have_content objective.department.name
    expect(page).to have_content objective.title
    expect(page).to have_content objective.description
    expect(page).to have_content "Cumplido: Sí"
   
  end

  scenario 'Edit' do  
    visit edit_objective_path(objective)

    expect(page).to have_content objective.department.area.name
    expect(page).to have_content objective.department.name
    expect(page).to have_content objective.title

    within ('.edit_objective') do
      expect(page).to have_selector("#objective_title", objective.title )
      expect(page).to have_selector("#objective_description", objective.description )
    end
  end 
end