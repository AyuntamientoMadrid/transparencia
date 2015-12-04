require 'rails_helper'

describe Contract do

  describe "search" do

    context "attributes" do

      it "searches by center" do
        contract = create(:contract, center: 'Administration')
        results = Contract.search('Administration')
        expect(results).to eq([contract])
      end

      it "searches by organism" do
        contract = create(:contract, organism: 'Health')
        results = Contract.search('Health')
        expect(results).to eq([contract])
      end

      it "searches by contract_number" do
        contract = create(:contract, contract_number: '12345678')
        results = Contract.search('12345678')
        expect(results).to eq([contract])
      end

      it "searches by document_number" do
        contract = create(:contract, document_number: '87654321')
        results = Contract.search('87654321')
        expect(results).to eq([contract])
      end

      it "searches by description" do
        contract = create(:contract, description: 'This contract is for building...')
        results = Contract.search('This contract is for building')
        expect(results).to eq([contract])
      end

      it "searches by kind" do
        contract = create(:contract, kind: 'Service')
        results = Contract.search('Service')
        expect(results).to eq([contract])
      end

      it "searches by award_procedure" do
        contract = create(:contract, award_procedure: 'Open')
        results = Contract.search('Open')
        expect(results).to eq([contract])
      end

      it "searches by award_criteria" do
        contract = create(:contract, award_criteria: 'Green factor')
        results = Contract.search('Green factor')
        expect(results).to eq([contract])
      end

      it "searches by recipient" do
        contract = create(:contract, recipient: 'Dolphin warriors')
        results = Contract.search('Dolphin warriors')
        expect(results).to eq([contract])
      end

      it "searches by recipient_document_number" do
        contract = create(:contract, recipient_document_number: '12345678Z')
        results = Contract.search('12345678Z')
        expect(results).to eq([contract])
      end

    end

    context "stemming" do

      it "searches word stems" do
        contract = create(:contract, recipient: 'plan')

        results = Contract.search('planos')
        expect(results).to eq([contract])

        results = Contract.search('planas')
        expect(results).to eq([contract])
      end

    end

    context "accents" do

      it "searches with accents" do
        contract = create(:contract, recipient: 'difusión')

        results = Contract.search('difusion')
        expect(results).to eq([contract])

        contract2 = create(:contract, recipient: 'estadisticas')
        results = Contract.search('estadísticas')
        expect(results).to eq([contract2])
      end

    end

    context "case" do

      it "searches case insensite" do
        contract = create(:contract, recipient: 'SHOUT')

        results = Contract.search('shout')
        expect(results).to eq([contract])

        contract2 = create(:contract, recipient: "scream")
        results = Contract.search("SCREAM")
        expect(results).to eq([contract2])
      end

    end

    context "no results" do

      it "no words match" do
        contract = create(:contract, recipient: 'save world')

        results = Contract.search('destroy planet')
        expect(results).to eq([])
      end

      it "too much stemming" do
        contract = create(:contract, recipient: 'reloj')

        results = Contract.search('superreloimetroasdfa')
        expect(results).to eq([])
      end

      it "empty" do
        contract = create(:contract, recipient: 'great')

        results = Contract.search('')
        expect(results).to eq([])
      end

    end

  end

end