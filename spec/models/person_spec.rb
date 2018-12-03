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

  describe "activities_declaration order" do

    it "puts initial first, final last, and the rest by declaration_date" do
      person  = create(:person)
      initial = create(:activities_declaration, person: person, period: 'initial')
      final   = create(:activities_declaration, person: person, period: 'final')
      recent  = create(:activities_declaration, person: person, declaration_date: 1.day.ago)
      old     = create(:activities_declaration, person: person, declaration_date: 1.year.ago)

      expect(person.activities_declarations.to_a).to eq([initial, old, recent, final])
    end
  end

  describe "assets_declarations order" do
    it "puts initial first, final last, and the rest by declaration_date" do
      person  = create(:person)
      initial = create(:assets_declaration, person: person, period: 'initial')
      final   = create(:assets_declaration, person: person, period: 'final')
      recent  = create(:assets_declaration, person: person, declaration_date: 1.day.ago)
      old     = create(:assets_declaration, person: person, declaration_date: 1.year.ago)

      expect(person.assets_declarations.to_a).to eq([initial, old, recent, final])
    end

  end

  describe ".grouped_by_party" do
    it "orders councillors from the same party by councillor code" do
      party = create(:party)
      first_councillor = create(:person, councillor_code: 1, party: party)
      councillor_without_code = create(:person, councillor_code: nil, party: party)
      third_councillor = create(:person, councillor_code: 3, party: party)
      second_councillor = create(:person, councillor_code: 2, party: party)

      expect(Person.grouped_by_party[party]).to eq [first_councillor, second_councillor, third_councillor, councillor_without_code]
    end
  end
end
