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
    expect(page).to have_content "Cumplido: Sí"
   
  end

  scenario 'Edit' do  
    visit edit_objective_path(objective)

    expect(page).to have_content objective.department.area.name
    expect(page).to have_content objective.department.name
    expect(page).to have_content objective.title

    within ('.edit_objective') do
      expect(page).to have_selector("#objective_title", objective.title )
      expect(page).to have_selector("#objective_description", objective.description )
      expect(page).to have_selector("#objective_accomplished", "Cumplido" )
      expect(find("#objective_accomplished")).to be_checked
    end
  end 

  scenario 'Update objective' do  
    visit edit_objective_path(objective)      
    
    expect(find("#objective_accomplished")).to be_checked

    fill_in 'objective_title', with: 'edit titulo'
    fill_in 'objective_description', with: 'edit descripcion'
    uncheck 'Cumplido'
    click_on('Actualizar')

    expect(page).to have_content "edit titulo"
    expect(page).to have_content "edit descripcion"
    expect(page).to have_content "Cumplido: No"

    expect(page).to have_content "El objetivo se ha actualizado correctamente."
  end  


  scenario 'cannot be updated' do  
    visit edit_objective_path(objective)      
    
    expect(find("#objective_accomplished")).to be_checked

    fill_in 'objective_title', with: ''
    fill_in 'objective_description', with: 'edit descripcion'
    uncheck 'Cumplido'
    click_on('Actualizar')

    expect(page).to have_content "no puede estar en blanco"
    expect(page).to have_content "Hubo un error durante la actualización. Revise el formulario."
  end   


end