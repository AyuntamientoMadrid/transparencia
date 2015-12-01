require 'importers/base_importer'

module Importers
  module Activities
    class PublicImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.activities_declarations.last!

          entity     = row[:entidad]
          position   = row[:cargo_o_categoria]
          start_date = row[:fecha_inicio]
          end_date   = row[:fecha_cese]

          unless declaration.has_public_activity?(entity, position, start_date, end_date)
            puts "Importing public activity for #{person.name} (#{entity}, #{position}, #{start_date}, #{end_date})"
            declaration.add_public_activity(entity, position, start_date, end_date)
            declaration.save!
          end
        end
      end
    end
  end
end
