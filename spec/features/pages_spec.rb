require 'rails_helper'

feature 'Pages' do

  describe "index" do

    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { create(:page, parent: page3) }

    scenario "should show first level nodes when no page selected", js: true do
      visit pages_path

      expect(page).to have_content page1.title
      expect(page).to have_selector(".page", count: 1)
    end

    scenario "should show first level nodes when page selected", js: true do
      visit pages_path(selected: page1.id)

      expect(page).to have_content page1.title
      expect(page).to have_selector(".column_left .page", count: 1)
      expect(page).to have_selector(".column_center .page", count: 1)      
    end

    scenario "should show first and second level nodes when first level page is selected", js: true do
      visit pages_path(selected: page2.id)

      expect(page).to have_content page1.title
      expect(page).to have_content page2.title
      expect(page).to have_selector(".column_left .page", count: 1)
      expect(page).to have_selector(".column_center .page", count: 1)    
      expect(page).to have_selector(".column_right .page", count: 1)    
    end    

  end

  describe "new" do
  end

  describe "edit" do
  end

  describe "update" do
  end

end