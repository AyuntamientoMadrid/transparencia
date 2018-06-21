require 'rails_helper'

feature 'Admin/People/AssetsDeclarations' do

  let!(:person) { create(:person, job_level: :temporary_worker) }
  let!(:councillor) { create(:person, job_level: :councillor) }
  let!(:administrator) { create(:administrator) }

  before(:each) { login_as administrator }

  feature "Create" do

    scenario 'Create a minimun person', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select "Directive", from: :person_job_level
      fill_in :person_role, with: "Level 3 Research Associate"

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Freeman, Gordon"

      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"

      expect(page).to have_content '2018-01-01'

    end

    scenario 'Create a person', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select  "Directive", from: 'person_job_level'
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

      within '#private_activities' do
        element = all(:css, "input[name*='[kind]']").first
        fill_in element[:name], with: 'kind_1'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_1'

        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_1'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'position_1'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/03/2018'
      end

      within '#other_activities' do
        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_2'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/04/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/05/2018'
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

      expect(page).to have_content 'kind_1'
      expect(page).to have_content 'description_1'
      expect(page).to have_content 'entity_1'
      expect(page).to have_content 'position_1'
      expect(page).to have_content '01/03/2018'

      expect(page).to have_content 'description_2'
      expect(page).to have_content "01/04/2018"
      expect(page).to have_content "01/05/2018"
    end
  end

  context "Update" do

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

    scenario 'Update, add activity declarations with 2 private activities', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#private_activities' do

        element = all(:css, "input[name*='[kind]']").first
        fill_in element[:name], with: 'kind_1'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_1'

        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_1'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'position_1'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/02/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/03/2018'
      end

      within '#private-activities-add' do
        click_link 'Add'
      end

      within '#private_activities' do
        element = all(:css, "input[name*='[kind]']").last
        fill_in element[:name], with: 'kind_2'

        element = all(:css, "input[name*='[description]']").last
        fill_in element[:name], with: 'description_2'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content 'description_1'
      expect(page).to have_content 'entity_1'
      expect(page).to have_content 'position_1'
      expect(page).to have_content '01/02/2018'
      expect(page).to have_content '01/03/2018'

      expect(page).to have_content 'kind_2'
      expect(page).to have_content 'description_2'

    end

    scenario 'Update, edit activity declarations (private)', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")
      declaration = ActivitiesDeclaration.create(person_id: person.id,
                                                 declaration_date: '01/01/2018',
                                                 period: 'position_1')
      declaration.add_private_activity('Private', 'Very Private', 'Entity', 'position', '1/1/2016', '1/1/2017')

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '02/01/2018'

      within '#private_activities' do

        element = all(:css, "input[name*='[kind]']").first
        fill_in element[:name], with: 'kind_1'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_1'

        element = all(:css, "input[name*='[entity]']").first
        fill_in element[:name], with: 'entity_1'

        element = all(:css, "input[name*='[position]']").first
        fill_in element[:name], with: 'position_1'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/02/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/03/2018'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "kind_1"
      expect(page).to have_content "description_1"
      expect(page).to have_content "entity_1"
      expect(page).to have_content "position_1"
      expect(page).to have_content "01/02/2018"
      expect(page).to have_content "01/03/2018"
    end

    scenario 'Update, add activity declarations with 2 other activities', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#other_activities' do

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_1'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/02/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/03/2018'
      end

      within '#other-activities-add' do
        click_link 'Add'
      end

      within '#other_activities' do
        element = all(:css, "input[name*='[description]']").last
        fill_in element[:name], with: 'description_2'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content 'description_1'
      expect(page).to have_content '01/02/2018'
      expect(page).to have_content '01/03/2018'

      expect(page).to have_content 'description_2'
    end

    scenario 'Update, edit activity declarations (other)', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")
      declaration = ActivitiesDeclaration.create(person_id: person.id,
                                                 declaration_date: '01/01/2018',
                                                 period: 'position_1')
      declaration.add_other_activity('Other', '1/2/2016', '1/3/2017')

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Activities declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '02/01/2018'

      within '#other_activities' do

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_2'

        element = all(:css, "input[name*='[start_date]']").first
        fill_in element[:name], with: '01/04/2018'

        element = all(:css, "input[name*='[end_date]']").first
        fill_in element[:name], with: '01/05/2018'
      end

      within '#activities_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "description_2"
      expect(page).to have_content "01/04/2018"
      expect(page).to have_content "01/05/2018"
    end

  end

  context "Errors" do

    scenario 'Show errors on empty form (with assets and activities)', :js do
      visit new_admin_person_path

      click_link 'Activities declarations'

      fill_in :person_activities_declarations_attributes_0__period, with: "period"

      click_button 'Submit'

      expect(page).to have_content("Declaration date can't be blank")
    end
  end

end