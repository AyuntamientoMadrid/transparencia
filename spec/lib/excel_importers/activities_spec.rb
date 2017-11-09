require 'rails_helper'
require 'excel_importers/activities'
require 'importers/parties_importer'
require 'importers/councillors_importer'

describe ExcelImporters::Activities, clean_as_group: true do
  describe '#import', clean_as_group: true do
    let(:declaration) { Person.where(personal_code: 64385).first.activities_declarations.first}

    before(:all) do
      Importers::PartiesImporter.new('./import-data/parties.csv').import!
      Importers::CouncillorsImporter.new('./spec/fixtures/files/councillors.csv').import!
      ExcelImporters::Activities.new('./spec/fixtures/files/activities.xls', 'inicial').import
    end

    it 'Parses declarations' do
      expect(declaration.period).to eq('inicial')
      expect(declaration.declaration_date).to eq(Date.new(2017, 5, 30))
    end

    it 'Parses public activities' do
      job = declaration.public_activities[0]
      expect(job.entity).to eq('Comunidad de Madrid')
      expect(job.position.strip).to eq('Asesor')
      expect(job.end_date).to be_nil
      expect(job.start_date).to eq('2016-12-28')

      job = declaration.public_activities[1]
      expect(job.entity).to eq('Comunidad de Madrid')
      expect(job.position.strip).to eq('Director General de Relaciones')
      expect(job.start_date).to eq('20/09/2008')
      expect(job.end_date).to eq("Previsto cese con efectos del día 13 junio)")

      job = declaration.public_activities[2]
      expect(job.entity).to eq('Comunidad de Madrid')
      expect(job.position.strip).to eq('Director General de Archivo')
      expect(job.start_date).to be_nil
      expect(job.end_date).to eq('2015-12-06')

      job = declaration.public_activities[3]
      expect(job.entity).to eq('Hospital La Paz')
      expect(job.position.strip).to eq('Psicológo clínico facultativo')
      expect(job.start_date).to eq(2005)
      expect(job.end_date).to eq('2015-12-06')

      job = declaration.public_activities[4]
      expect(job.entity).to eq('Universidad Autónoma')
      expect(job.position.strip).to eq('Profesor asociado master')
      expect(job.start_date).to eq(2013)
      expect(job.end_date).to be_nil

      job = declaration.public_activities[5]
      expect(job.entity).to eq('Agencia Tributaria')
      expect(job.position.strip).to eq('Jefe Equipo Inspección')
      expect(job.start_date).to be_nil
      expect(job.end_date).to be_nil
    end

    it 'Parses private activities' do
      job = declaration.private_activities[0]
      expect(job.kind).to eq('Actividades mercantiles o industriales')
      expect(job.description).to eq('Gimnasio')
      expect(job.entity).to eq('Sagasta Fenómeno SL')
      expect(job.position).to eq('33% Participación')
      expect(job.end_date).to be_nil
      expect(job.start_date).to eq('2016-02-23')

      job = declaration.private_activities[1]
      expect(job.kind).to eq('Actividades y ocupaciones profesionales')
      expect(job.description).to eq('Profesor asociado master. Pendiente solicitar compatibilidad')
      expect(job.entity).to eq('Universidad Comillas')
      expect(job.position).to eq('Profesor master')
      expect(job.start_date).to eq(2011)
      expect(job.end_date).to be_nil

      job = declaration.private_activities[2]
      expect(job.kind).to eq('Actividades por cuenta ajena')
      expect(job.description).to eq('Letrada en excedencia forzosa')
      expect(job.entity).to eq('Legalitas SL')
      expect(job.position).to eq('Letrada')
      expect(job.start_date).to be_nil
      expect(job.end_date).to eq('13/06/2015')

      job = declaration.private_activities[3]
      expect(job.kind).to eq('Actividades y ocupaciones profesionales')
      expect(job.description).to eq('Guión Serie TV')
      expect(job.entity).to eq('ASACINE Producoes')
      expect(job.position).to be_nil
      expect(job.start_date).to eq('24/03/2015')
      expect(job.end_date).to eq('13/06/2015')
    end

    it 'Parses other activities' do
      job = declaration.other_activities[0]
      expect(job.description).to eq("Colaboraciones con medios de comunicación, colaboraciones en revistas, generalmente no remuneradas")
      expect(job.end_date).to be_nil
      expect(job.start_date).to eq('2016-02-23')

      job = declaration.other_activities[1]
      expect(job.description).to eq("Circunstancialmente docencia en universidades públicas y privadas (conferencias, cursos, posgrados)")
      expect(job.start_date).to be_nil
      expect(job.end_date).to eq('2015-12-16')
    end
  end
end
