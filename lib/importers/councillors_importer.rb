require 'importers/base_importer'

module Importers
  class CouncillorsImporter < BaseImporter
    def import!
      each_row do |row|
        councillor = Person.find_or_initialize_by(first_name: row[:first_name], last_name: row[:last_name])
        puts "Importing councillor: #{councillor.name}"
        councillor.job_level = 'councillor'
        councillor.councillor_code = row[:councillor_code]
        councillor.personal_code = row[:personal_code]
        councillor.party = Party.find_by!(long_name: row[:party_long_name])
        councillor.email = "tmp@madrid.es"
        councillor.role = row[:post]
        councillor.previous_calendar_until = row[:previous_calendar_until]
        councillor.previous_calendar = row[:previous_calendar]
        councillor.save!
      end
    end
  end
end
