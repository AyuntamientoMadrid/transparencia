require 'rails_helper'

feature 'Admin Assets Uploads' do
  scenario 'Administrator can show/index past uploads' do
    admin1 = create(:administrator, email: 'admin1@example.com')
    admin2 = create(:administrator, email: 'admin2@example.com')
    create(:assets_upload, author: admin1, log: 'p1')
    create(:assets_upload, author: admin2, log: 'p2')
    login_as admin1
    visit admin_root_path

    click_link 'Assets uploads'

    click_link admin1.email

    expect(page).to have_content 'p1'

    click_link 'Back to the list'

    click_link admin2.email

    expect(page).to have_content 'p2'
  end

  scenario 'Administrator can upload correct xls files' do
    person = create(:person, personal_code: 2379, first_name: "Pepe", last_name: "Lopez")
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Assets uploads'
    click_link 'Upload a new file'

    attach_file('assets_upload_file', Rails.root.join('spec/fixtures/files/single_assets.xls'))
    page.select('initial', from: 'assets_upload_period')

    click_button 'Submit'

    expect(page).to have_content 'Original filename: single_assets.xls'
    expect(page).to have_content 'File format: xls'
    expect(page).to have_content 'File processed successfully'
    expect(page).to have_content 'Assets declaration for Pepe Lopez'

    visit person_path(person)
    expect(page).to have_content 'Initial'
  end

  scenario 'Administrator can upload xls file with error' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Assets uploads'
    click_link 'Upload a new file'

    attach_file('assets_upload_file', Rails.root.join('spec/fixtures/files/single_assets.xls'))
    page.select('initial', from: 'assets_upload_period')

    click_button 'Submit'

    expect(page).to have_content "Couldn't find Person"
  end

  scenario 'Administrator can attempt to upload random files from internet without the app crashing' do
    create(:person, personal_code: 2379)
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Assets uploads'
    click_link 'Upload a new file'

    attach_file('assets_upload_file', Rails.root.join('spec/fixtures/files/banana.gif'))
    page.select('initial', from: 'assets_upload_period')
    click_button 'Submit'

    expect(page).to have_content 'Errors were detected while processing the file'
    expect(page).to have_content "Can't detect the type"
  end
end

