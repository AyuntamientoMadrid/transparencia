require 'rails_helper'

feature 'Authorization' do

  context "Access only to full features set to true" do

    background do
      allow_any_instance_of(ApplicationController).
      to receive(:only_full_features?).and_return(true)
    end

    scenario "Do not allow access to WIP features" do
      expect { visit pages_path }.to raise_error(ActionController::RoutingError)
    end

    scenario "Allow access to home" do
      visit "/"
      expect(page).to have_content "Welcome to the transparency portal"
    end

    scenario "Allow access to people index" do
      visit people_path
      expect(page).to have_content "Councillors"
    end

    scenario "Allow access to people show" do
      person = create(:person)
      visit person_path(person)
      expect(page).to have_content person.name
    end
  end

  context "Access only to full feature set to false" do

    background do
      allow_any_instance_of(ApplicationController).
      to receive(:only_full_features?).and_return(false)
    end

    scenario "Allow access to WIP features" do
      create(:page)
      visit pages_path
      expect(page).to have_content "What are you looking for?"
    end

  end

end