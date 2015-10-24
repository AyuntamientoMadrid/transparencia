require 'rails_helper'

feature 'Objectives' do

  let!(:area)        { create(:area) }
  let!(:department)  { create(:department, area: area) }
  let!(:objective)   { create(:objective, department: department) }

  scenario 'Show' do
    visit objective_path(objective)

    expect(page).to have_content objective.department.area.name
    expect(page).to have_content objective.department.name
    expect(page).to have_content objective.title
    expect(page).to have_content objective.description
    expect(page).to have_content "Cumplido: No"
  end

  scenario 'Edit', js: true do  
    visit edit_objective_path(objective)

    expect(page).to have_content objective.department.area.name
    expect(page).to have_content objective.department.name
    expect(page).to have_content objective.title

    within ('.edit_objective') do
      expect(page).to have_selector("#objective_title", objective.title )

      expect(page).to have_selector("#objective_accomplished", "Cumplido" )
      expect(find("trix-editor")).to have_content(objective.description)
      expect(find("#objective_accomplished")).to_not be_checked
    end
  end

  scenario 'Update objective', js: true do  
    Capybara.ignore_hidden_elements = false
    visit edit_objective_path(objective)      
    
    expect(find("#objective_accomplished")).to_not be_checked

    fill_in 'objective_title', with: 'edit titulo'
    find("#objective_description_trix_input_objective_1").set("edit description")
    uncheck 'Cumplido'
    click_on('Actualizar')

    expect(page).to have_content "edit titulo"
    expect(page).to have_content "edit description"
    expect(page).to have_content "Cumplido: No"

    expect(page).to have_content "El objetivo se ha actualizado correctamente."
    Capybara.ignore_hidden_elements = true
  end  


  scenario 'error messages', js: true do  
    Capybara.ignore_hidden_elements = false
    visit edit_objective_path(objective)      
    
    expect(find("#objective_accomplished")).to_not be_checked

    fill_in 'objective_title', with: ''
    find("#objective_description_trix_input_objective_1").set("")
    uncheck 'Cumplido'
    click_on('Actualizar')

    expect(page).to have_content "no puede estar en blanco"
    expect(page).to have_content "Hubo un error durante la actualización. Revise el formulario."
    Capybara.ignore_hidden_elements = true
  end   

end