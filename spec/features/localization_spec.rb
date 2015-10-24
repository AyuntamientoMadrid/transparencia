require 'rails_helper'

feature 'Localization' do

  scenario 'Wrong locale' do
    visit root_path(locale: :es)
    visit root_path(locale: :klingon)

    expect(page).to have_text('Transparencia')
  end

  scenario 'Changing the locale', :js do
    visit root_path(locale: :en)

    expect(page).to have_text('Transparency')
  end
end
