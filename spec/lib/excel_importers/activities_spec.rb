require 'rails_helper'
require 'excel_importers/activities'
require 'importers/parties_importer'
require 'importers/councillors_importer'

describe ExcelImporters::Activities, clean_as_group: true do
  describe '#import', clean_as_group: true do
    before(:all) do
      Importers::PartiesImporter.new('./import-data/parties.csv').import!
      Importers::CouncillorsImporter.new('./import-data/councillors.csv').import!
      ExcelImporters::Activities.new('./spec/fixtures/files/activities.xls', 'inicial').import
      @person2 = Person.where(councillor_code: 2).first
    end

    it 'Parses declarations' do
      declaration = Person.where(councillor_code: 1).first.activities_declarations.first
      expect(declaration.period).to eq('inicial')
      expect(declaration.declaration_date).to eq(Date.new(2015,6,12))
    end

    it 'Parses public activities' do
      declaration = Person.where(councillor_code: 3).first.activities_declarations.first
      job = declaration.public_activities.first
      expect(job.entity).to eq('Administración General del Estado')
      expect(job.position.strip).to eq('Abogado del Estado')
      expect(job.start_date).to eq('2015-08-05')
      expect(job.end_date).to be_nil
    end

    it 'Parses private activities' do
      declaration = Person.where(councillor_code: 2).first.activities_declarations.first
      job = declaration.private_activities.first
      expect(job.kind).to eq('Actividades mercantiles o industriales')
      expect(job.description).to eq('Sociedad Agraria de Transformación')
      expect(job.entity).to eq('SAT 9763 Agrícola mecánica')
      expect(job.position).to eq('Secretario')
      expect(job.start_date).to eq('09/09/1995')
      expect(job.end_date).to be_nil
    end

    it 'Parses other activities' do
      declaration = Person.where(councillor_code: 1).first.activities_declarations.first
      job = declaration.other_activities.first

      expect(job.description).to eq("Patrona sin retribución de las fundaciones: FAES, Teatro Lirico, Miguel\nÁngel Blanco, Euramérica, Ortega Marañón")
      expect(job.start_date).to be_nil
      expect(job.start_date).to be_nil
    end
  end
end
