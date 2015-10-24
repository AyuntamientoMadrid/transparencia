require 'rails_helper'

feature 'Departments' do
  scenario 'Index' do
    #departments = [create(:department), create(:department), create(:department)]
    create(:department)
    
    visit departments_path

    expect(page).to have_selector('.areas .area', count: 3)
    expect(page).to have_selector('.areas .area .departments .department', count: 3)

    departments.each do |departments|
      within('.department') do
        expect(page).to have_content department.name
        expect(page).to have_css("a[href='#{department_path(department)}']", text: department.name)
      end
    end
  end

  scenario 'Show' do
    department = create :department

    visit department_path(department)

    within first('.department') do
      expect(page).to have_content department.name
      # more expects... have links...
    end
  end
  
end