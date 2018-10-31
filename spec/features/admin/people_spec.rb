require 'rails_helper'

feature 'Admin/People' do

  let!(:person) { create(:person, job_level: :temporary_worker) }
  let!(:councillor) { create(:person, job_level: :councillor) }
  let!(:administrator) { create(:administrator) }

  before(:each) { login_as administrator }

  feature "Hide and unhide" do
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

    scenario "Hide leaving a blank date", :js do
      visit admin_people_path

      within("#person_#{person.id}") { click_link "Hide" }
      within("#person_#{person.id}_hide_form") { click_button "Submit" }

      visit hidden_people_admin_people_path

      within("#person_#{person.id}") do
        expect(page).to have_content(I18n.localize(Date.current))
      end
    end

    scenario "Unhide leaving a blank date", :js do
      person.hide(administrator, 'A reason for hiding', Date.new(2016,1,1))

      visit hidden_people_admin_people_path

      within("#person_#{person.id}") { click_link "Unhide" }
      within("#person_#{person.id}_unhide_form") { click_button "Submit" }

      visit admin_people_path

      within("#person_#{person.id}") do
        expect(page).to have_content(I18n.localize(Date.current))
      end
    end

  end

  context 'Person' do

    feature 'Create' do

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

      scenario 'Create' do
        visit new_admin_person_path
        fill_in :person_first_name, with: "Gordon"
        fill_in :person_last_name, with: "Freeman"
        select  "Temporary worker", from: 'person_job_level'
        fill_in :person_role, with: "Level 3 Research Associate"

        within '#main_form' do
          click_button 'Submit'
        end

        visit temporary_workers_people_path

        expect(page).to have_content "Gordon Freeman"

        person = Person.last
        visit person_path(person)
        expect(page).to have_content "Gordon Freeman"
        expect(page).to have_content "Level 3 Research Associate"
      end

      scenario 'Create with attached image' do
        visit new_admin_person_path
        fill_in :person_first_name, with: "Gordon"
        fill_in :person_last_name, with: "Freeman"
        select  "Directive", from: 'person_job_level'
        fill_in :person_role, with: "Level 3 Research Associate"
        page.attach_file("person_portrait", Rails.root + 'app/assets/images/people_example.jpg')

        within '#main_form' do
          click_button 'Submit'
        end

        visit person_path(Person.last.id)

        expect(page).to have_xpath("//img[contains(@src, \"gordon-freeman.jpg\")]")

      end

      scenario 'Create without attached image' do
        visit new_admin_person_path
        fill_in :person_first_name, with: "Gordon"
        fill_in :person_last_name, with: "Freeman"
        select  "Councillor", from: 'person_job_level'
        fill_in :person_role, with: "Level 3 Research Associate"

        within '#main_form' do
          click_button 'Submit'
        end

        visit person_path(Person.last.id)

        expect(page).to have_xpath("//img[contains(@alt, \"\")]")

      end
    end

    context 'Update' do

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
        person = create(:person, first_name: "Vlad",
                                 last_name: "Tepes",
                                 role: "Voivode of Wallachia",
                                 secondary_role: "Military leader",
                                 job_level: "director")

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

      scenario "Update 'portrait' attached image" do
        person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "councillor")

        visit person_path(person)
        click_on "Edit"

        page.attach_file("person_portrait", Rails.root + 'app/assets/images/people_example.jpg')

        within '#main_form' do
          click_button 'Submit'
        end

        visit councillors_people_path

        expect(page).to have_xpath("//img[contains(@src, \"red-richards.jpg\")]")

        visit person_path(person.id)

        expect(page).to have_xpath("//img[contains(@src, \"red-richards.jpg\")]")

      end
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

    context 'Errors' do

      scenario 'Show errors on empty form (without assets and activities)', :js do
        visit new_admin_person_path

        select "Councillor", from: 'person_job_level'

        click_button 'Submit'

        expect(page).to have_content("First name can't be blank")
        expect(page).to have_content("Last name can't be blank")
        expect(page).to have_content("Role can't be blank")
        expect(page).to have_content("Party can't be blank")
      end
    end
  end

end
