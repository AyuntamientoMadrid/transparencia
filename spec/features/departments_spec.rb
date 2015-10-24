require 'rails_helper'

feature 'Department' do

  let!(:area)        { create(:area) }
  let!(:departments) { create_list(:department, 1, area: area) }
  let!(:objectives)  { create_list(:objective, 2, department: departments.first)}

  scenario 'Show' do
    department = departments.first

    visit department_path(department)

    expect(page).to have_content department.area.name
    expect(page).to have_content department.name
    expect(page).to have_content department.description
    expect(page).to have_content department.directives
    
    department.objectives.each do |objective|
      expect(page).to have_css("a[href='#{objective_path(objective)}']", text: objective.title)
    end

  end
  
end