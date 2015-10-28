require 'rails_helper'

feature 'Pages' do

  describe "index" do

    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { create(:page, parent: page3, link: "http:/google.com") }

    scenario "should show first level nodes when no page selected" do
      visit pages_path

      expect(page).to have_content page1.title
      expect(page).to have_selector(".page", count: 1)
    end

    scenario "should show first level nodes when page selected" do
      visit pages_path
      click_on page1.title

      expect(page).to have_content page1.title
      expect(page).to have_selector(".column_left .page", count: 1)
      expect(page).to have_selector(".column_center .page", count: 1)      
    end

    scenario "should show first and second level nodes when first level page is selected" do
      visit pages_path
      click_on page1.title
      click_on page2.title

      expect(page).to have_content page1.title
      expect(page).to have_content page2.title
      expect(page).to have_selector(".column_left .page", count: 1)
      expect(page).to have_selector(".column_center .page", count: 1)    
      expect(page).to have_selector(".column_right .page", count: 2)    
    end    

  end

  describe "new level 1 node" do

    scenario "should allow to create a level 1 page" do
      visit new_page_path

      fill_in "Título", with: "Título nivel 1"

      click_on "Guardar"

      expect(page).to have_content "Se ha añadido una nueva página correctamente."
      expect(page).to have_content "Título nivel 1"
    end

    scenario "should show validation error when invalid page" do
      visit new_page_path

      fill_in "Título", with: ""

      click_on "Guardar"

      expect(page).to have_content "Hubo un error al guardar el contenido, revise el formulario."
    end    
  end

  describe "new level 2 node" do

    let!(:page1)  { create(:page) }

    scenario "should allow to create a level 2 page" do
      visit new_page_path

      select page1.title, from: "Página padre"
      fill_in "Título", with: "Título nivel 2"

      click_on "Guardar"

      expect(page).to have_content "Se ha añadido una nueva página correctamente."
      expect(page).to have_content "Título nivel 2"
    end

    scenario "should show validation error when invalid page" do
      visit new_page_path

      select page1.title, from: "Página padre"
      fill_in "Título", with: ""

      click_on "Guardar"

      expect(page).to have_content "Hubo un error al guardar el contenido, revise el formulario."
    end    
  end  

  describe "new level 3 node" do

    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }

    scenario "should allow to create a level 3 page" do
      skip "Error desconocido"
      visit new_page_path

      select page2.title, from: "Página padre"
      fill_in "Título", with: "Título nivel 3"

      click_on "Guardar"

      expect(page).to have_content "Se ha añadido una nueva página correctamente."
      expect(page).to have_content "Título nivel 3"
    end

    scenario "should show validation error when invalid page" do
      skip "Error desconocido"
      visit new_page_path

      select page2.title, from: "Página padre"
      fill_in "Título", with: ""

      click_on "Guardar"

      expect(page).to have_content "Hubo un error al guardar el contenido, revise el formulario."
    end    
  end   

  describe "edit" do
    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1, link: "https://google.com") }

    scenario "should allow to edit pages" do
      visit edit_page_path(page1)

      expect(find('#page_title').value).to eq(page1.title)
      expect(find('#page_link').value).to eq(page1.link)
    end   

  end

  describe "update" do
    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }

    scenario "should allow to update pages" do
      visit edit_page_path(page1)

      fill_in "Título", with: "Título actualizado"

      click_on "Guardar"

      expect(page).to have_content "Se ha modificado la página correctamente."
      expect(page).to have_content "Título actualizado"
    end  
  end

end