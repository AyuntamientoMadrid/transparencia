require 'importers/base_importer'

module Importers
  class PartiesImporter < BaseImporter
    def import!
      each_row do |row|
        party = Party.find_or_initialize_by(name: row[:nombre])
        puts "Importing party: #{party.name}"
        party.long_name = row[:nombre_largo]
        party.logo = row[:logo]
        party.save!
      end
    end
  end
end
