require 'rails_helper'
require 'excel_importers/base'

describe ExcelImporters::Base do
  let(:importer) { ExcelImporters::Base.new('./spec/fixtures/files/profiles.xls', 2) }

  describe '#headers' do
    subject { importer.headers }
    it 'is an array' do
      expect(subject).to be_an(Array)
    end
    it 'contains the strings on the first row of the first sheet' do
      expect(subject.first).to eq('Fecha')
      expect(subject.last).to eq('Resultado')
    end
  end

  describe '#each_row' do
    it 'receives a hash with the headers transliteraded and symbolized' do
      count = 0
      importer.each_row do |row|
        count += 1
        expect(row).to have_key(:fecha)
        expect(row[:fecha]).to eq(row[0])

        expect(row).to have_key(:"1_titulacion_oficial")
        expect(row[:"1_titulacion_oficial"]).to eq(row[11])
      end
      expect(count).to be > 0
    end
  end

  describe 'index' do
    it 'returns the address of the header specified' do
      expect(importer.index(:"1_titulacion_oficial")).to eq(11)
    end
  end

  describe 'cell transformations' do

    it "does not transform integers into floats" do
      year = nil
      importer.each_row do |row|
        if row[:n_personal] == 2379 then
          year = row[importer.index(:"1_titulacion_oficial") + 2]
          break
        end
      end
      expect(year).to be_an(Integer)
    end

    it "does not allow NULL fields to pass" do
      studies_comment = nil
      importer.each_row do |row|
        if row[:n_personal] == 2379  then
          studies_comment = row[importer.index(:"4_titulacion_oficial") + 4]
          break
        end
      end

      expect(studies_comment).to be_nil
      expect(studies_comment).to_not eq('NULL')
    end

  end

end
