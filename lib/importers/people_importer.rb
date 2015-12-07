require 'importers/base_importer'

module Importers
  class PeopleImporter < BaseImporter
    def import!
      each_row do |row|
        name = "#{row[:nombre]} #{row[:apellido_1]} #{row[:apellido_2]}"
        person = Person.find_or_initialize_by(name: name)
        puts "Importing person: #{person.name}"
        person.councillor_code = row[:codigoconcejal]
        person.party = Party.find_by!(long_name: row[:grupo_politico])
        person.email = "tmp@madrid.es"
        person.role = row[:cargo]
        person.save!
      end
    end
  end
end
