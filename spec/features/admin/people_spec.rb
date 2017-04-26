require 'rails_helper'

feature 'Admin/People' do

  let!(:person) { create(:person, job_level: :temporary_worker) }

  before(:each) { login_as create(:administrator) }

  scenario 'Hiding a normal user (show view) and unhiding from admin view', :js do
    visit person_path(person)
    click_link 'Hide'
    fill_in(:person_hidden_reason, with: 'A reason for hiding')
    click_button 'Submit'

    expect(page).to have_content 'Person hidden successfully'
    expect(page).to have_link 'Unhide'

    visit admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      click_link 'Unhide'
    end
    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'
  end

  scenario 'Unhiding a hidden user (show view) and hiding from admin view', :js do
    person.hide(create(:administrator), 'A reason for hiding')

    visit admin_people_path
    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_link 'Unhide'
    end

    visit person_path(person)
    click_link 'Unhide'
    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'

    visit admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_content 'A reason for unhiding'
      expect(page).to have_link 'Hide'
    end
  end

end
