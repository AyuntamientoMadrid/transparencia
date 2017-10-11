require 'rails_helper'

feature 'People' do

  let!(:person) { create(:person) }

  xscenario 'Contact validation' do
    visit person_path(person)
    click_on('send_message')
    expect(page).to have_css('#contact_alert')
  end

  xscenario 'Contact correctly sent' do
    visit person_path(person)
    fill_in(:contact_name, with: "Robert Smith")
    fill_in(:contact_email, with: "robert@smith.com")
    fill_in(:contact_body, with: "hello")

    click_on('send_message')
    expect(page).to have_css('#contact_notice')

    last_email = ActionMailer::Base.deliveries.last

    expect(last_email.to[0]).to eq(person.email)
    expect(last_email.subject).to include("Robert Smith")
    body = last_email.body.encoded
    expect(body).to include("Robert Smith")
    expect(body).to include("robert@smith.com")
    expect(body).to include("hello")
  end

  context 'Admin actions' do
    background do
      login_as create(:administrator)
    end

    scenario 'Create' do
      visit new_person_path
      fill_in :person_first_name, with: "Gordon"
      fill_in :person_last_name, with: "Freeman"
      select  "Temporary worker", from: 'person_job_level'
      fill_in :person_role, with: "Level 3 Research Associate"
      submit_form

      visit temporary_workers_people_path
      expect(page).to have_content "Freeman, Gordon"

      person = Person.last
      visit person_path(person)
      expect(page).to have_content "Gordon Freeman"
      expect(page).to have_content "Level 3 Research Associate"
    end

    scenario 'Update' do
      person = create(:person, first_name: "Red", last_name: "Richards", role: "Elastic Man", job_level: "director")

      visit person_path(person)
      click_on "Edit"

      fill_in :person_unit, with: "Fantastic 4"
      submit_form

      visit directors_people_path
      expect(page).to have_content person.backwards_name
      expect(page).to have_content person.unit

      visit person_path(person)
      expect(page).to have_content(person.name)
      expect(page).to have_content(person.role)
      expect(page).to have_content(person.unit)
    end

    scenario 'Delete' do
      person = create(:person, first_name: "Klark", last_name: "Kent", role: "Tank")

      visit person_path(person)
      click_on "Delete"

      visit directors_people_path
      expect(page).to_not have_content "Klark Kent"
    end
  end

  describe "Show people", clean_as_group: true do
    let(:person){create(:person, first_name: 'Bruce', last_name: 'Waine', role: 'Batman', job_level: 'director')}

    scenario "directors's declarations" do
      create(:assets_declaration, person: person, declaration_date: '2017-09-06', period: 'initial', data: {real_estate_properties: [{'kind' => "Urbano", 'description' => "Batcave", 'municipality' => "Gotham"}]})

      visit person_path(person)

      expect(page).to have_content(person.assets_declarations.first.declaration_date)
      expect(page).to have_content("Urbano")
      expect(page).to have_content("Batcave")
      expect(page).to have_content("Gotham")
    end

    scenario "director's activities" do
      create(:activities_declaration, person: person, declaration_date: '2017-09-07', period: 'initial', data: {public_activities: ['entity' => 'Gotham', 'position' => 'City rescuer', 'start_date' => 1.year.ago]})

      visit person_path(person)

      expect(page).to have_content(person.activities_declarations.first.declaration_date)
      expect(page).to have_content('Gotham')
      expect(page).to have_content('City rescuer')
    end

    scenario "spokesperson's profile" do
      person = create(:person, first_name: 'Robin', last_name: 'The Boy Wonder', role: 'Robin', job_level: 'spokesperson')

      visit spokespeople_people_path

      click_on "The Boy Wonder, Robin"

      expect(page).to have_content("Professional profile")
      expect(page).to have_content("Robin The Boy Wonder")
    end
  end

end
