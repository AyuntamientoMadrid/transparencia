require 'importers/base_importer'

module Importers
  class CouncillorsImporter < BaseImporter
    def import!
      each_row do |row|
        councillor = Person.find_or_initialize_by(name: row[:name])
        puts "Importing councillor: #{councillor.name}"
        councillor.job_level = 'councillor'
        councillor.councillor_code = row[:councillor_code]
        councillor.personal_code = row[:personal_code]
        councillor.party = Party.find_by!(long_name: row[:party_long_name])
        councillor.email = "tmp@madrid.es"
        councillor.role = row[:post]
        councillor.save!
      end
    end
  end
end
