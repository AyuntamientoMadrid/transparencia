require 'rails_helper'

describe Person do

  describe "Slug" do

    it "should store a slugged name" do
      person = create(:person, first_name: "Eduard", last_name: "Johnson")
      expect(person.friendly_id).to eq "eduard-johnson"
    end

    it "should deal with special characters" do
      person = create(:person, first_name: "Belén", last_name: "Castaño")
      expect(person.friendly_id).to eq "belen-castano"
    end

    it "should be findable by slug" do
      person = create(:person, first_name: "Eduard", last_name: "Johnson")
      expect(person).to eq Person.friendly.find("eduard-johnson")
    end

    it "should be findable by id" do
      person = create(:person, first_name: "Eduard", last_name: "Johnson")
      expect(person).to eq Person.friendly.find(person.id)
    end

  end

end
