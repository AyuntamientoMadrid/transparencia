require 'rails_helper'
require 'excel_importers/profile'
require 'importers/parties_importer'
require 'importers/councillors_importer'

describe ExcelImporters::Profile, clean_as_group: true do
  [
    ExcelImporters::Profile.new('./spec/fixtures/files/profiles.xls', header_field: 'Fecha'),
    ExcelImporters::Profile.new('./spec/fixtures/files/profiles_2.xls', header_field: 'Fecha'),
  ].each do |importer|

    describe '#import!', clean_as_group: true do
      before(:all) do
        Importers::PartiesImporter.new('./import-data/parties.csv').import!
        Importers::CouncillorsImporter.new('./import-data/councillors.csv').import!
        importer.import!
      end

      it 'Parses job levels correctly' do
        expect(Person.where(personal_code: '84855').first.job_level).to eq('director')
        expect(Person.where(personal_code: '171053').first.job_level).to eq('councillor')
      end

      it 'Uses the last profile date for updating' do
        p = Person.where(personal_code: '171179').first
        expect(p.role).to eq('DIRECTOR/A OFICINA')
        # There is an older role called 'DIRECTOR GENERAL' for this person
      end

      it 'Imports basic profile info' do
        p = Person.where(personal_code: '171053').first

        attributes = %w(
          first_name last_name role job_level
          twitter facebook unit
        )
        expect(p.attributes.slice(*attributes)).to eq(
          'facebook' => nil,
          'first_name' => 'Manuela',
          'job_level' => 'councillor',
          'last_name' => 'Carmena Castrillo',
          'role' => 'Alcaldesa',
          'twitter' => nil,
          'unit' => 'ALCALDE'
        )
      end
    end
  end
end
