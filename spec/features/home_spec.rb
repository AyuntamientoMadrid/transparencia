require 'rails_helper'

feature 'Home' do

  scenario 'Welcome' do
    visit root_path
    expect(page).to have_content "Transparencia"
  end

end