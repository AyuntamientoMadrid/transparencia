require 'rails_helper'

feature 'Area' do

  let!(:area)        { create(:area) }
  let!(:departments) { create_list(:department, 1, area: area) }

  scenario 'Index' do

    visit areas_path
    expect(page).to have_selector('.areas .area', count: 1 )
    expect(page).to have_selector('.areas .area .departments .department', count: 1)

    departments.each do |department|
      within('.department') do
        expect(page).to have_content department.name
        expect(page).to have_css("a[href='#{department_path(department)}']", text: department.name)
      end
    end
  end
 
end