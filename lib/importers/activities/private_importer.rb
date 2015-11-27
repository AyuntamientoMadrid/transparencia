require 'importers/base_importer'

module Importers
  module Activities
    class PrivateImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.activities_declarations.last!

          kind        = row[:actividad]
          description = row[:descripcion]
          entity      = row[:entidadcolegio_profesional]
          position    = row[:cargo_o_categoria]
          start_date  = parse_spanish_date(row[:fecha_inicio])
          end_date    = parse_spanish_date(row[:fecha_cese])

          unless declaration.has_private_activity?(kind, description, entity, position, start_date, end_date)
            puts "Importing private activity for #{person.name} (#{entity}, #{position}, #{start_date}, #{end_date})"
            declaration.add_private_activity(kind, description, entity, position, start_date, end_date)
            declaration.save!
          end
        end
      end
    end
  end
end
