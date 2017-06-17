require 'rails_helper'
require 'excel_importers/assets'
require 'importers/parties_importer'
require 'importers/councillors_importer'

describe ExcelImporters::Assets, clean_as_group: true do
  describe '#import', clean_as_group: true do
    let(:declaration) { Person.where(personal_code: 64385).first.assets_declarations.first }

    before(:all) do
      Importers::PartiesImporter.new('./import-data/parties.csv').import!
      Importers::CouncillorsImporter.new('./spec/fixtures/files/councillors.csv').import!
      ExcelImporters::Assets.new('./spec/fixtures/files/assets.xls', 'inicial').import
    end

    it 'Parses declarations' do
      expect(declaration.period).to eq('inicial')
      expect(declaration.declaration_date).to eq(Date.new(2017, 0o5, 30))
    end

    it 'Parses real estate properties' do
      prop = declaration.real_estate_properties[0]
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to be_nil
      expect(prop.share).to eq(5)
      expect(prop.purchase_date).to be_nil
      expect(prop.tax_value).to eq("4.081,78 €")
      expect(prop.notes).to eq('Apartamento')

      prop = declaration.real_estate_properties[1]
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to be_nil
      expect(prop.share).to eq(50)
      expect(prop.purchase_date).to eq('1978')
      expect(prop.tax_value).to eq("En curso")
      expect(prop.notes).to eq('Parking')

      prop = declaration.real_estate_properties[2]
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to eq('Pleno dominio')
      expect(prop.share).to eq(50)
      expect(prop.purchase_date).to eq('25-04-2002')
      expect(prop.tax_value).to eq("170.584,90 €")
      expect(prop.notes).to eq('Trastero')

      prop = declaration.real_estate_properties[3]
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to eq('Pleno dominio')
      expect(prop.share).to eq(50)
      expect(prop.purchase_date).to eq('01-04-1990')
      expect(prop.tax_value).to eq("14.194,54 €")
      expect(prop.notes).to be_nil

      prop = declaration.real_estate_properties[4]
      expect(prop.kind).to eq('Urbano')
      expect(prop.type).to eq('Pleno dominio')
      expect(prop.share).to eq(100)
      expect(prop.purchase_date).to eq('01-06-1997')
      expect(prop.tax_value).to eq("249.255,00 €")
      expect(prop.notes).to be_nil
    end

    it 'Parses account deposits' do
      prop = declaration.account_deposits.first
      expect(prop.kind).to eq('Cuenta corriente')
      expect(prop.banking_entity).to eq('Bankia')
      expect(prop.balance).to eq("3.812,36 €")

      prop = declaration.account_deposits.second
      expect(prop.kind).to eq('Cuenta corriente')
      expect(prop.banking_entity).to eq('Bankia (Caja Ávila)')
      expect(prop.balance).to eq("0,00 €")
    end

    it 'Parses other deposits' do
      prop = declaration.other_deposits[0]
      expect(prop.kind).to eq('Acciones y participaciones en sociedades')
      expect(prop.description).to eq('Club de golf')
      expect(prop.amount).to eq("24.000,00 €")
      expect(prop.purchase_date).to eq("27-12-2007")

      prop = declaration.other_deposits[1]
      expect(prop.kind).to eq('Seguros de vida, planes de pensiones, rentas temporales y vitalicias')
      expect(prop.description).to eq('PP SANTANDER 2009 IBEX')
      expect(prop.amount).to eq("55%\n")
      expect(prop.purchase_date).to be_nil

      prop = declaration.other_deposits[2]
      expect(prop.kind).to eq('Seguros de vida, planes de pensiones, rentas temporales y vitalicias')
      expect(prop.description).to eq('Plan de pensiones banco Santander')
      expect(prop.amount).to eq("46.485,37 €")
      expect(prop.purchase_date).to eq("Anterior 2010")

      prop = declaration.other_deposits[3]
      expect(prop.kind).to eq('Acciones y participaciones en sociedades')
      expect(prop.description).to eq('TELEFONICA S.A.')
      expect(prop.amount).to eq("12.289 Títulos")
      expect(prop.purchase_date).to eq("2004")

      prop = declaration.other_deposits[4]
      expect(prop.kind).to eq('Seguros de vida, planes de pensiones, rentas temporales y vitalicias')
      expect(prop.description).to eq('Plan de Pensiones La Caixa')
      expect(prop.amount).to eq('45000')
      expect(prop.purchase_date).to be_nil
    end

    it 'Parses vehicles' do
      prop = declaration.vehicles[0]
      expect(prop.kind).to eq('Automóviles')
      expect(prop.model).to eq('Toyota Verso')
      expect(prop.purchase_date).to eq("2013")

      prop = declaration.vehicles[1]
      expect(prop.kind).to eq('Automóviles')
      expect(prop.model).to eq('Audi Q5 (Segunda mano)')
      expect(prop.purchase_date).to eq('01-10-2013')

      prop = declaration.vehicles[2]
      expect(prop.kind).to eq('Automóviles')
      expect(prop.model).to eq('Volvo XC 60 (segunda mano)')
      expect(prop.purchase_date).to eq('20-01-2014')
    end

    it 'Parses other personal properties' do
      prop = declaration.other_personal_properties.first
      expect(prop.kind).to eq('Joyas')
      expect(prop.purchase_date).to eq('2001')

      prop = declaration.other_personal_properties.second
      expect(prop.kind).to eq('Trofeos')
      expect(prop.purchase_date).to be_nil
    end

    it 'Parses debts' do
      prop = declaration.debts.first
      expect(prop.kind).to eq('Pago impuestos fraccionados')
      expect(prop.amount).to eq('45.551,00 €')
      expect(prop.comments).to eq('Nanclares de Oca')

      prop = declaration.debts.second
      expect(prop.kind).to eq('Rendimientos negativos: ')
      expect(prop.amount).to eq('Por convenio regulador de divorcio sufraga las diferencias')
      expect(prop.comments).to eq('Pedro Rico')
    end
  end
end
