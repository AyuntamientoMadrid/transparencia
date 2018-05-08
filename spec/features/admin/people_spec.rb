require 'rails_helper'

feature 'Admin/People' do

  let!(:person) { create(:person, job_level: :temporary_worker) }
  let!(:councillor) { create(:person, job_level: :councillor) }
  let!(:administrator) { create(:administrator) }

  before(:each) { login_as administrator }

  scenario 'Hiding a normal user and unhiding', :js do
    visit admin_people_path

    within("#person_#{person.id}") do
      click_link 'Hide'
    end

    within("#person_#{person.id}_hide_form") do
      fill_in(:person_hidden_reason, with: 'A reason for hiding')
      fill_in(:person_hidden_at, with: '1/1/2016')
      click_button 'Submit'
    end

    expect(page).to have_content 'Person hidden successfully'

    visit hidden_people_admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_content '2016-01-01'
      click_link 'Unhide'
    end

    within("#person_#{person.id}_unhide_form") do
      fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
      fill_in(:person_unhidden_at, with: '13/03/2016')
      click_button 'Submit'
    end

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'
  end

  scenario 'Unhiding a hidden user and hiding', :js do

    person.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

    visit hidden_people_admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_content 'A reason for hiding'
      expect(page).to have_content '2016-01-01'
      click_link 'Unhide'
    end

    within("#person_#{person.id}_unhide_form") do
      fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
      fill_in(:person_unhidden_at, with: '13/03/2016')
      click_button 'Submit'
    end

    expect(page).to have_content 'Person unhidden successfully'
    expect(page).to have_link 'Hide'

    visit admin_people_path

    within("#person_#{person.id}") do
      expect(page).to have_link 'Hide'
    end

  end

  scenario 'Users can be hidden and restored more than once', :js do
    councillor.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

    visit hidden_people_admin_people_path

    within("#person_#{councillor.id}") do
      expect(page).to have_content(councillor.backwards_name)
      expect(page).to have_content('A reason for hiding')
      expect(page).to have_content('2016-01-01')
      expect(page).to have_link('Unhide')
      click_link 'Unhide'
    end

    within("#person_#{councillor.id}_unhide_form") do
      fill_in(:person_unhidden_reason, with: 'A reason for unhiding')
      fill_in(:person_unhidden_at, with: '13/03/2016')
      click_button 'Submit'
    end

    expect(page).to have_content('Person unhidden successfully')
    within("#person_#{councillor.id}") do
      expect(page).to have_content(councillor.backwards_name)
      expect(page).to have_link('Hide')
      click_link 'Hide'
    end

    within("#person_#{councillor.id}_hide_form") do
      fill_in(:person_hidden_reason, with: 'Another reason for hiding')
      fill_in(:person_hidden_at, with: '12/01/2018')
      click_button 'Submit'
    end

    expect(page).to have_content('Person hidden successfully')

    visit hidden_people_admin_people_path
    within("#person_#{councillor.id}") do
      expect(page).to have_content(councillor.backwards_name)
      expect(page).to have_content('Another reason for hiding')
      expect(page).to have_link('Unhide')
      click_link 'Unhide'
    end

    within("#person_#{councillor.id}_unhide_form") do
      fill_in(:person_unhidden_reason, with: 'Yet another reason for unhiding')
      fill_in(:person_unhidden_at, with: '13/01/2018')
      click_button 'Submit'
    end

    expect(page).to have_content('Person unhidden successfully')
    within("#person_#{councillor.id}") do
      expect(page).to have_content(councillor.backwards_name)
      expect(page).to have_link('Hide')
    end

  end

  context 'Admin actions' do

    scenario 'Create a minimun person (without assets and activities)' do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select  "Temporary worker", from: 'person_job_level'
      fill_in :person_role, with: "Level 3 Research Associate"

      within("#main_form") do
        find('input[name="commit"]').click
      end

      visit temporary_workers_people_path
      expect(page).to have_content "Gordon Freeman"

      person = Person.last
      visit person_path(person)
      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"
    end

    scenario 'Create a minimun person (with activities)', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select "Councillor", from: :person_job_level
      fill_in :person_role, with: "Level 3 Research Associate"

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      element = all(:css, "input[name*='[period]']").first
      fill_in element[:name], with: 'period_1'

      click_button 'Submit'

      click_link "Freeman, Gordon"

      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"

      expect(page).to have_content '2018-01-01'

    end

    scenario 'Show errors on empty form (without assets and activities)', :js do
      visit new_admin_person_path

      click_button 'Submit'

      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Role can't be blank")
    end

    scenario 'Show errors on empty form (with assets and activities)', :js do
      visit new_admin_person_path

      click_link 'Activities declarations'

      fill_in :person_activities_declarations_attributes_0__period, with: "period"

      click_button 'Submit'

      expect(page).to have_content("Declaration date can't be blank")
    end

    scenario 'Create a person with activities declarations', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select  "Councillor", from: 'person_job_level'
      fill_in :person_role, with: "Level 3 Research Associate"

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#public_activities' do
        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_0'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'position_0'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/01/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/02/2018'
      end

      click_button 'Submit'

      click_link "Freeman, Gordon"

      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"

      expect(page).to have_content "2018-01-01"

      expect(page).to have_content "entity_0"
      expect(page).to have_content "position_0"
      expect(page).to have_content "01/01/2018"
      expect(page).to have_content "01/02/2018"
    end

    scenario 'Update' do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      fill_in :person_unit, with: "Fantastic 4"
      fill_in :person_secondary_role, with: "Marlon Brando"

      within("#main_form") do
        find('input[name="commit"]').click
      end

      visit directors_people_path
      expect(page).to have_content "Red Richards"
      expect(page).to have_content person.unit

      visit person_path(person)
      expect(page).to have_content(person.name)
      expect(page).to have_content(person.role)
      expect(page).to have_content(person.unit)
      expect(page).to have_content(person.secondary_role)
    end

    scenario "Update 'secondary_role' attribute" do
      person = create(:person, first_name: "Vlad", last_name: "Tepes", role: "Voivode of Wallachia", secondary_role: "Military leader", job_level: "director")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      within("#main_form") do
        fill_in(:person_secondary_role, with: 'National hero of Romania')
        find('input[name="commit"]').click
      end

      visit person_path(person)

      expect(page).to have_content(person.name)
      expect(page).to have_content(person.role)
      expect(page).to have_content('National hero of Romania')
      expect(page).to_not have_content('Military leader')
    end

    scenario 'Update, add activity declarations with 2 public activities', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "councillor")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#public_activities' do
        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_0'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'post_0'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/02/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/03/2018'
      end

      within '#public-activities-add' do
        click_link 'Add'
      end

      within '#public_activities' do
        element = all(:css, "input[name*='[position]']").last

        fill_in element[:name], with: 'position_01'

        element = all(:css, "input[name*='[entity]']").last
        fill_in element[:name], with: 'entity_01'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "entity_0"
      expect(page).to have_content "post_0"
      expect(page).to have_content "2018-01-01"
      expect(page).to have_content "01/02/2018"
      expect(page).to have_content "01/03/2018"

      expect(page).to have_content "entity_01"
      expect(page).to have_content 'position_01'

    end

    scenario 'Update, edit activity declarations', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")
      declaration = ActivitiesDeclaration.create(person_id: person.id,
                                                 declaration_date: '01/01/2018',
                                                 period: 'position_1')
      declaration.add_public_activity('entity_0','post_0','01/02/2018','01/03/2018')

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '02/01/2018'

      within '#public_activities' do
        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_2'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'post_2'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '02/01/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '02/02/2018'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "entity_2"
      expect(page).to have_content "post_2"
      expect(page).to have_content "02/01/2018"
      expect(page).to have_content "02/02/2018"
    end

    scenario 'Delete' do
      person = create(:person, first_name: "Klark", last_name: "Kent", role: "Tank")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Delete"
      end

      visit directors_people_path
      expect(page).to_not have_content "Klark Kent"
    end
  end

end
