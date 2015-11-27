require 'importers/base_importer'

module Importers
  module Activities
    class OtherImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.activities_declarations.last!

          description = row[:descripcion]
          start_date  = parse_spanish_date(row[:fecha_inicio])
          end_date    = parse_spanish_date(row[:fecha_cese])

          unless declaration.has_other_activity?(description, start_date, end_date)
            puts "Importing other activity for #{person.name} (#{start_date}, #{end_date})"
            declaration.add_other_activity(description, start_date, end_date)
            declaration.save!
          end
        end
      end
    end
  end
end
