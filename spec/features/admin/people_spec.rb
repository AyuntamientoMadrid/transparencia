require 'rails_helper'

feature 'Admin/People' do

  let!(:person) { create(:person, job_level: :temporary_worker) }
  let!(:councillor) { create(:person, job_level: :councillor) }
  let!(:administrator) { create(:administrator) }

  before(:each) { login_as administrator }

  scenario 'Hiding a normal user (show view) and unhiding from admin view', :js do
    visit person_path(person)
    click_link 'Hide'
    fill_in(:person_hidden_reason, with: 'A reason for hiding')
    fill_in(:person_hidden_at, with: '1/1/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person hidden successfully'
    expect(page).to have_link 'Unhide'

    visit admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_content '2016-01-01'
      click_link 'Unhide'
    end

    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/03/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'
  end

  scenario 'Unhiding a hidden user (show view) and hiding from admin view', :js do
    person.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

    visit admin_people_path
    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_link 'Unhide'
    end

    visit person_path(person)
    click_link 'Unhide'
    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/03/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'

    visit admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for unhiding'
      expect(page).to have_content '2016-03-13'
      expect(page).to have_link 'Hide'
    end
  end

  scenario 'Hiding a councillor (show view) and unhiding from admin view', :js do
    visit person_path(councillor)
    click_link 'Hide'
    fill_in(:person_hidden_reason, with: 'A reason for hiding')
    fill_in(:person_hidden_at, with: '1/1/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person hidden successfully'
    expect(page).to have_link 'Unhide'

    visit councillors_people_path
    expect(page).to_not have_content(councillor.name)

    click_link 'Not working'

    expect(page).to have_content(councillor.name)

    visit admin_people_path

    within("#person_#{councillor.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_content '2016-01-01'
      click_link 'Unhide'
    end

    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/03/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'

    visit councillors_people_path
    expect(page).to have_content(councillor.name)
  end

  scenario 'Unhiding a hidden councillor (show view) and hiding from admin view', :js do
    councillor.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

    visit councillors_people_path
    expect(page).to_not have_content(councillor.name)

    click_link 'Not working'

    expect(page).to have_content(councillor.name)

    visit admin_people_path
    within("#person_#{councillor.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_link 'Unhide'
    end

    visit person_path(councillor)
    click_link 'Unhide'
    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/03/2016')
    click_button 'Submit'

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'

    visit admin_people_path

    within("#person_#{councillor.id}") do
      expect(page).to have_content 'A reason for unhiding'
      expect(page).to have_content '2016-03-13'
      expect(page).to have_link 'Hide'
    end

    visit councillors_people_path
    expect(page).to have_content(councillor.name)
  end

  scenario 'Users can be hidden and restored more than once', :js do
    councillor.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

    visit admin_people_path

    within("#person_#{councillor.id}") do
      expect(page).to have_content(councillor.backwards_name)
      expect(page).to have_content('A reason for hiding')
      expect(page).to have_content('2016-01-01')
      expect(page).to have_link('Unhide')
      click_link 'Unhide'
    end

    fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/03/2016')
    click_button 'Submit'

    expect(page).to have_content(councillor.name)
    expect(page).to have_content('Person unhidden successfully')
    expect(page).to have_link('Hide')
    click_link 'Hide'

    fill_in(:person_hidden_reason, with: 'Another reason for hiding')
    fill_in(:person_hidden_at, with: '12/01/2018')
    click_button 'Submit'

    expect(page).to have_content(councillor.name)
    expect(page).to have_content('Person hidden successfully')
    expect(page).to have_content('Leaving date: 2018-01-12')
    expect(page).to have_link('Unhide')
    click_link 'Unhide'

    fill_in(:person_unhidden_reason, with: 'Yet another reason for unhiding')
    fill_in(:person_unhidden_at, with: '13/01/2018')
    click_button 'Submit'

    expect(page).to have_content(councillor.name)
    expect(page).to have_content('Person unhidden successfully')
    expect(page).to have_link('Hide')
  end

end
