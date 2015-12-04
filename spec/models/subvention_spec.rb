require 'rails_helper'

describe Subvention do

  describe "search" do

    context "attributes" do

      it "searches by recipient" do
        subvention = create(:subvention, recipient: 'Children of the green')
        results = Subvention.search('children of the green')
        expect(results).to eq([subvention])
      end

      it "searches by subtitle" do
        subvention = create(:subvention, project: 'This project is about trees')
        results = Subvention.search('project about trees')
        expect(results).to eq([subvention])
      end

      it "searches by kind" do
        subvention = create(:subvention, kind: 'Cooperation')
        results = Subvention.search('Cooperation')
        expect(results).to eq([subvention])
      end

      it "searches by location" do
        subvention = create(:subvention, location: 'Brazil')
        results = Subvention.search('Brazil')
        expect(results).to eq([subvention])
      end

      it "searches by year" do
        subvention = create(:subvention, year: '1995')
        results = Subvention.search('1995')
        expect(results).to eq([subvention])
      end

    end

    context "stemming" do

      it "searches word stems" do
        subvention = create(:subvention, project: 'plan')

        results = Subvention.search('planos')
        expect(results).to eq([subvention])

        results = Subvention.search('planas')
        expect(results).to eq([subvention])
      end

    end

    context "accents" do

      it "searches with accents" do
        subvention = create(:subvention, project: 'difusión')

        results = Subvention.search('difusion')
        expect(results).to eq([subvention])

        subvention2 = create(:subvention, project: 'estadisticas')
        results = Subvention.search('estadísticas')
        expect(results).to eq([subvention2])
      end

    end

    context "case" do

      it "searches case insensite" do
        subvention = create(:subvention, project: 'SHOUT')

        results = Subvention.search('shout')
        expect(results).to eq([subvention])

        subvention2 = create(:subvention, project: "scream")
        results = Subvention.search("SCREAM")
        expect(results).to eq([subvention2])
      end

    end

    context "no results" do

      it "no words match" do
        subvention = create(:subvention, project: 'save world')

        results = Subvention.search('destroy planet')
        expect(results).to eq([])
      end

      it "too much stemming" do
        subvention = create(:subvention, project: 'reloj')

        results = Subvention.search('superreloimetroasdfa')
        expect(results).to eq([])
      end

      it "empty" do
        subvention = create(:subvention, project: 'great')

        results = Subvention.search('')
        expect(results).to eq([])
      end

    end

  end

end