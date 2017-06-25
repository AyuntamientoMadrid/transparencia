require 'rails_helper'

feature 'Admin Activities Uploads' do
  scenario 'Administrator can show/index past uploads' do
    admin1 = create(:administrator, email: 'admin1@example.com')
    admin2 = create(:administrator, email: 'admin2@example.com')
    create(:activities_upload, author: admin1, log: 'p1')
    create(:activities_upload, author: admin2, log: 'p2')
    login_as admin1
    visit admin_root_path

    click_link 'Activities uploads'

    click_link admin1.email

    expect(page).to have_content 'p1'

    click_link 'Back to the list'

    click_link admin2.email

    expect(page).to have_content 'p2'
  end

  scenario 'Administrator can upload correct xls files' do
    person = create(:person, personal_code: 5697, first_name: "Pepe", last_name: "Lopez")
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Activities uploads'
    click_link 'Upload a new file'

    attach_file('activities_upload_file', Rails.root.join('spec/fixtures/files/single_activities.xls'))
    page.select('initial', from: 'activities_upload_period')

    click_button 'Submit'

    expect(page).to have_content 'Original filename: single_activities.xls'
    expect(page).to have_content 'File format: xls'
    expect(page).to have_content 'File processed successfully'
    expect(page).to have_content 'Activity declaration for Pepe Lopez'

    visit person_path(person)
    expect(page).to have_content 'Initial'
  end

  scenario 'Administrator can upload xls file with error' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Activities uploads'
    click_link 'Upload a new file'

    attach_file('activities_upload_file', Rails.root.join('spec/fixtures/files/single_activities.xls'))
    page.select('initial', from: 'activities_upload_period')

    click_button 'Submit'

    expect(page).to have_content "Couldn't find Person"
  end

  scenario 'Administrator can attempt to upload random files from internet without the app crashing' do
    create(:person, personal_code: 5697)
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Activities uploads'
    click_link 'Upload a new file'

    attach_file('activities_upload_file', Rails.root.join('spec/fixtures/files/banana.gif'))
    page.select('initial', from: 'activities_upload_period')
    click_button 'Submit'

    expect(page).to have_content 'Errors were detected while processing the file'
    expect(page).to have_content "Can't detect the type"
  end
end

