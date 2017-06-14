require 'rails_helper'
require 'excel_importers/assets'
require 'importers/parties_importer'
require 'importers/councillors_importer'

describe ExcelImporters::Assets, clean_as_group: true do
  describe '#import', clean_as_group: true do
    let(:declaration) { Person.where(personal_code: 2379).first.assets_declarations.first }
    before(:all) do
      Importers::PartiesImporter.new('./import-data/parties.csv').import!
      Importers::CouncillorsImporter.new('./import-data/councillors.csv').import!
      ExcelImporters::Assets.new('./spec/fixtures/files/assets.xls', 'inicial').import
    end

    it 'Parses declarations' do
      expect(declaration.period).to eq('inicial')
      expect(declaration.declaration_date).to eq(Date.new(2015, 11, 16))
    end

    it 'Parses real estate properties' do
      prop = declaration.real_estate_properties.first
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to be_nil
      expect(prop.share).to eq(5)
      expect(prop.purchase_date).to be_nil
      expect(prop.tax_value).to eq("4.081,78 €")
      expect(prop.comments).to be_nil
    end

    it 'Parses account deposits' do
      prop = declaration.account_deposits.first
      expect(prop.kind).to eq('Cuenta corriente')
      expect(prop.banking_entity).to eq('Bankia')
      expect(prop.balance).to eq("3.812,36 €")
    end

    it 'Parses other deposits' do
      prop = declaration.other_deposits.first
      expect(prop.kind).to eq('Acciones y participaciones de todo tipo en sociedades e instituciones de inversión colectiva')
      expect(prop.description).to eq('Club de golf')
      expect(prop.amount).to eq("24.000,00 €")
      expect(prop.purchase_date).to eq("27/12/2007")
    end

    it 'Parses vehicles' do
      prop = declaration.vehicles.first
      expect(prop.kind).to eq('Automóviles')
      expect(prop.model).to eq('Toyota Verso')
      expect(prop.purchase_date).to eq("2013")
    end

    it 'Parses other personal properties' do
      prop = declaration.other_personal_properties.first
      expect(prop.kind).to eq('Joyas')
      expect(prop.purchase_date).to be_nil
    end

    it 'Parses debts' do
      prop = declaration.debts.first
      expect(prop.kind).to eq('Pago impuestos fraccionados')
      expect(prop.amount).to eq('45.551,00 €')
      expect(prop.comments).to be_nil
    end
  end
end
