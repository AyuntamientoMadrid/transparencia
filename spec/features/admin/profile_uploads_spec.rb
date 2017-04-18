require 'rails_helper'

feature 'Admin Profile Uploads' do
  scenario 'Administrator can upload correct xls files' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/single_profile.xls'))
    click_button 'Submit'

    expect(page).to have_content 'File processed successfully'
    expect(page).to have_content 'Importing PABLO FERNANDEZ LEWICKI'
  end

  scenario 'Administrator can upload erroneous xls files' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/single_councillor.xls'))
    click_button 'Submit'

    expect(page).to have_content 'Errors were detected while processing the file'
    expect(page).to have_content "ERROR: Couldn't find Person"
  end

  scenario 'Administrator can attempt to upload random files from internet without the app crashing' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/banana.gif'))
    click_button 'Submit'

    expect(page).to have_content 'Errors were detected while processing the file'
    expect(page).to have_content "Can't detect the type"
  end
end

