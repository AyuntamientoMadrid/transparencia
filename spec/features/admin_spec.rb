require 'rails_helper'

feature 'Admin' do
  scenario 'Unregistered user gets a login screen' do
    visit admin_root_path

    expect(page).to have_content "Necesitas iniciar sesión"
    expect(current_path).to eq(new_administrator_session_path)
  end

  scenario 'Administrator can see the login screen after logging in' do
    admin = create(:administrator)

    visit admin_root_path

    expect(page).to have_content "Necesitas iniciar sesión"
    expect(current_path).to eq(new_administrator_session_path)

    fill_in(:administrator_email, with: admin.email)
    fill_in(:administrator_password, with: admin.password)

    submit_form

    expect(page).to have_content "Has iniciado sesión correctamente"

    expect(current_path).to eq(admin_root_path)
  end

  scenario 'Administrator can sign in quickly in the tests using login_as' do
    admin = create(:administrator)
    login_as admin

    visit admin_root_path
    expect(page).to_not have_content "Necesitas iniciar sesión"
    expect(current_path).to eq(admin_root_path)
  end
end
