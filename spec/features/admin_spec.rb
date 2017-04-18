require 'rails_helper'

feature 'Admin' do
  scenario 'Unregistered user gets a login screen' do
    visit admin_root_path

    expect(page).to have_content "You need to sign in or sign up before continuing"
    expect(current_path).to eq(new_administrator_session_path)
  end

  scenario 'Administrator can see the login screen after logging in' do
    admin = create(:administrator)

    visit admin_root_path

    expect(page).to have_content "You need to sign in or sign up before continuing"
    expect(current_path).to eq(new_administrator_session_path)

    fill_in(:administrator_email, with: admin.email)
    fill_in(:administrator_password, with: admin.password)

    submit_form

    expect(page).to have_content "Signed in successfully"

    expect(current_path).to eq(admin_root_path)
  end

  scenario 'Administrator can sign in quickly in the tests using login_as' do
    admin = create(:administrator)
    login_as admin

    visit admin_root_path
    expect(page).to_not have_content "You need to sign in or sign up before continuing"
    expect(current_path).to eq(admin_root_path)
  end

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
