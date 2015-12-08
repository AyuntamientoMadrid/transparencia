require 'importers/base_importer'

module Importers
  module Activities
    class OtherImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.activities_declarations.last!

          description = row[:descripcion]
          start_date  = row[:fecha_inicio]
          end_date    = row[:fecha_cese]

          puts "Importing other activity for #{person.name} (#{start_date}, #{end_date})"
          declaration.add_other_activity(description, start_date, end_date)
          declaration.save!
        end
      end
    end
  end
end
