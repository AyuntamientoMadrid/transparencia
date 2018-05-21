require 'rails_helper'

feature 'Admin/People/AssetsDeclarations' do

  let!(:person) { create(:person, job_level: :temporary_worker) }
  let!(:councillor) { create(:person, job_level: :councillor) }
  let!(:administrator) { create(:administrator) }

  before { login_as administrator }

  feature "Create" do
    scenario 'Create a minimun person (with assets)', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select "Directive", from: :person_job_level
      fill_in :person_role, with: "Level 3 Research Associate"

      click_link 'Assets declarations'

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

    scenario 'Create a person with Assets declarations', :js do

      visit new_admin_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select  "Directive", from: 'person_job_level'
      fill_in :person_role, with: "Level 3 Research Associate"

      click_link 'Assets declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#real_estate_properties' do

        element = all(:css, "input[name*='[kind']").first
        fill_in element[:name], with: 'kind_0'

        element = all(:css, "input[name*='[type]']").first
        fill_in element[:name], with: 'type_0'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_0'

        element = all(:css, "input[name*='[municipality]']").first
        fill_in element[:name], with: 'municipality_0'

        element = all(:css, "input[name*='[share]']").first
        fill_in element[:name], with: 'share_0'

        element = all(:css, "input[name*='[purchase_date]']").first
        fill_in element[:name], with: 'purchase_date_0'

        element = all(:css, "input[name*='[tax_value]']").first
        fill_in element[:name], with: 'tax_value_0'

        element = all(:css, "input[name*='[notes]']").first
        fill_in element[:name], with: 'notes_0'

      end

      click_button 'Submit'

      click_link "Freeman, Gordon"

      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"

      expect(page).to have_content "2018-01-01"

      expect(page).to have_content "kind_0"
      expect(page).to have_content "type_0"
      expect(page).to have_content "description_0"
      expect(page).to have_content "municipality_0"
      expect(page).to have_content "share_0"
      expect(page).to have_content "purchase_date_0"
      expect(page).to have_content "tax_value_0"
      expect(page).to have_content "notes_0"

    end
  end

  context "Update" do
    scenario 'Update, add assets declarations with 2 real estate properties', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Assets declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '01/01/2018'

      within '#real_estate_properties' do

        element = all(:css, "input[name*='[kind']").first
        fill_in element[:name], with: 'kind_0'

        element = all(:css, "input[name*='[type]']").first
        fill_in element[:name], with: 'type_0'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_0'

        element = all(:css, "input[name*='[municipality]']").first
        fill_in element[:name], with: 'municipality_0'

        element = all(:css, "input[name*='[share]']").first
        fill_in element[:name], with: 'share_0'

        element = all(:css, "input[name*='[purchase_date]']").first
        fill_in element[:name], with: 'purchase_date_0'

        element = all(:css, "input[name*='[tax_value]']").first
        fill_in element[:name], with: 'tax_value_0'

        element = all(:css, "input[name*='[notes]']").first
        fill_in element[:name], with: 'notes_0'

      end

      within '#real-state-properties-add' do
        click_link 'Add'
      end

      within '#real_estate_properties' do

        element = all(:css, "input[name*='[kind']").last
        fill_in element[:name], with: 'kind_1'

        element = all(:css, "input[name*='[type]']").last
        fill_in element[:name], with: 'type_1'

      end

      within '#assets_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "kind_0"
      expect(page).to have_content "type_0"
      expect(page).to have_content "description_0"
      expect(page).to have_content "municipality_0"
      expect(page).to have_content "share_0"
      expect(page).to have_content "purchase_date_0"
      expect(page).to have_content "tax_value_0"
      expect(page).to have_content "notes_0"

      expect(page).to have_content "kind_1"
      expect(page).to have_content "type_1"
    end

    scenario 'Update, edit assets declarations (real state property)', :js do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")
      declaration = AssetsDeclaration.create(person_id: person.id,
                                             declaration_date: '01/01/2018',
                                             period: 'position_1')
      declaration.add_real_estate_property('kind', 'type', 'description', 'municipality', 'share', 'purchase_date', 'tax_value', 'notes')

      visit admin_people_path

      within("#person_#{person.id}") do
        click_on "Edit"
      end

      click_link 'Assets declarations'

      element = all(:css, "input[name*='[declaration_date]']").first
      fill_in element[:name], with: '02/01/2018'

      within '#real_estate_properties' do

        element = all(:css, "input[name*='[kind']").first
        fill_in element[:name], with: 'kind_0'

        element = all(:css, "input[name*='[type]']").first
        fill_in element[:name], with: 'type_0'

        element = all(:css, "input[name*='[description]']").first
        fill_in element[:name], with: 'description_0'

        element = all(:css, "input[name*='[municipality]']").first
        fill_in element[:name], with: 'municipality_0'

        element = all(:css, "input[name*='[share]']").first
        fill_in element[:name], with: 'share_0'

        element = all(:css, "input[name*='[purchase_date]']").first
        fill_in element[:name], with: 'purchase_date_0'

        element = all(:css, "input[name*='[tax_value]']").first
        fill_in element[:name], with: 'tax_value_0'

        element = all(:css, "input[name*='[notes]']").first
        fill_in element[:name], with: 'notes_0'

      end

      within '#assets_declarations' do
        click_button 'Submit'
      end

      click_link "Richards, Red"

      expect(page).to have_content "kind_0"
      expect(page).to have_content "type_0"
      expect(page).to have_content "description_0"
      expect(page).to have_content "municipality_0"
      expect(page).to have_content "share_0"
      expect(page).to have_content "purchase_date_0"
      expect(page).to have_content "tax_value_0"
      expect(page).to have_content "notes_0"
    end

  end

  context "Errors" do

    scenario 'Show errors on empty form (with assets and assets)', :js do
      visit new_admin_person_path

      click_link 'Assets declarations'

      fill_in :person_assets_declarations_attributes_0__period, with: "period"

      click_button 'Submit'

      expect(page).to have_content("Declaration date can't be blank")
    end
  end

end