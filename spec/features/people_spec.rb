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

  describe "Show", clean_as_group: true do
    let(:person){create(:person, first_name: 'Bruce', last_name: 'Waine', role: 'Batman', job_level: 'director')}

    scenario "declarations" do
      create(:assets_declaration, person: person, declaration_date: '2017-09-06', period: 'initial',
                                  data: {real_estate_properties: [{'kind' => "Urbano",
                                                                   'description' => "Batcave",
                                                                   'municipality' => "Gotham"}]})

      visit person_path(person)

      expect(page).to have_content(person.assets_declarations.first.declaration_date)
      expect(page).to have_content("Urbano")
      expect(page).to have_content("Batcave")
      expect(page).to have_content("Gotham")
    end

    scenario "tax information" do
      create(:assets_declaration, person: person, declaration_date: '2017-09-06', period: 'initial',
                                  data: {tax_data: [{'tax' => "Impuesto sobre la Renta de las Personas Físicas",
                                                     'fiscal_data' => "Base imponible general",
                                                     'amount' => "600,00 €"}]})

      visit person_path(person)

      expect(page).to have_content(t("assets_declarations.tax_data.title"))
      expect(page).to have_content("Impuesto sobre la Renta de las Personas Físicas")
      expect(page).to have_content("Base imponible general")
      expect(page).to have_content("600,00 €")

      within("#activities_declarations") do
        expect(page).to have_content("The information will be published once the owner provides it.")
      end
    end

    scenario "activities declarations" do
      create(:activities_declaration, person: person, declaration_date: '2017-09-07', period: 'initial',
                                      data: {public_activities: ['entity' => 'Gotham',
                                                                 'position' => 'City rescuer',
                                                                 'start_date' => 1.year.ago],
                                             private_activities: ['kind' => 'kind_01',
                                                                  'description' => 'description_01',
                                                                  'entity' => 'entity_01',
                                                                  'position' => 'post_01',
                                                                  'start_date' => 2.years.ago,
                                                                  'end_date' => 3.years.ago],
                                             other_activities: ['description' => 'description_02',
                                                                'start_date' => 4.years.ago,
                                                                'end_date' => 5.years.ago]})

      visit person_path(person)

      expect(page).to have_content(person.activities_declarations.first.declaration_date)
      expect(page).to have_content('Gotham')
      expect(page).to have_content('City rescuer')

      expect(page).to have_content('kind_01')
      expect(page).to have_content('description_01')
      expect(page).to have_content('entity_01')
      expect(page).to have_content('post_01')
      expect(page).to have_content('description_02')

      within("#assets_declarations") do
        expect(page).to have_content("The information will be published once the owner provides it.")
      end
    end

    scenario "director with neither activity nor asset declarations" do
      visit person_path(person)

      within("#assets_declarations") do
        expect(page).to have_content("The information will be published once the owner provides it.")
      end

      within("#activities_declarations") do
        expect(page).to have_content("The information will be published once the owner provides it.")
      end
    end

    scenario "spokesperson's profile" do
      create(:person, first_name: 'Robin', last_name: 'The Boy Wonder', role: 'Robin', job_level: 'spokesperson')

      visit spokespeople_people_path

      click_on "Robin The Boy Wonder"

      expect(page).to have_content("Professional profile")
      expect(page).to have_content("Robin The Boy Wonder")
    end
  end

  feature "Directors" do
    let(:director) { create(:director, first_name: "Reed", last_name: "Richards") }

    scenario "with no party" do
      director.update(party: nil)

      visit directors_people_path

      expect(page).to have_content "Reed Richards"
      expect(page).to have_content "No assigned party"
    end
  end

end