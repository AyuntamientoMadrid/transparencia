require 'rails_helper'

xfeature 'Admin Profile Uploads' do
  scenario 'Administrator can show/index past uploads' do
    admin1 = create(:administrator, email: 'admin1@example.com')
    admin2 = create(:administrator, email: 'admin2@example.com')
    create(:profile_upload, author: admin1, log: 'p1')
    create(:profile_upload, author: admin2, log: 'p2')
    login_as admin1
    visit admin_root_path

    click_link 'Profile uploads'

    click_link admin1.email

    expect(page).to have_content 'p1'

    click_link 'Back to the list'

    click_link admin2.email

    expect(page).to have_content 'p2'
  end

  scenario 'Administrator can upload correct xls files' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/single_profile.xls'))
    click_button 'Submit'

    expect(page).to have_content 'Original filename: single_profile.xls'
    expect(page).to have_content 'File format: xls'
    expect(page).to have_content 'No errors while importing: Yes'
    expect(page).to have_content 'File processed successfully'
    expect(page).to have_content 'Importing PABLO FERNANDEZ LEWICKI'
  end

  scenario 'Administrator can upload html files masking as xls files' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/single_profile_html.xls'))
    click_button 'Submit'

    expect(page).to have_content 'Original filename: single_profile_html.xls'
    expect(page).to have_content 'File format: html'
    expect(page).to have_content 'No errors while importing: Yes'
    expect(page).to have_content 'File processed successfully'
  end

  scenario 'Administrator can upload erroneous xls files' do
    login_as create(:administrator)
    visit admin_root_path

    click_link 'Profile uploads'
    click_link 'Upload a new file'

    attach_file('profile_upload_file', Rails.root.join('spec/fixtures/files/single_councillor.xls'))
    click_button 'Submit'

    expect(page).to have_content 'Original filename: single_councillor.xls'
    expect(page).to have_content 'File format: xls'
    expect(page).to have_content 'No errors while importing: No'
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

