require 'rails_helper'

feature 'Area' do

  let!(:area) { create(:area) }

  scenario 'Index' do
    visit areas_path
    expect(page).to have_selector('.areas .area', count: 1 )
  end
 
end