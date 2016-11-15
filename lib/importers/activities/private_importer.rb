require 'importers/period_importer'

module Importers
  module Activities
    class PrivateImporter < PeriodImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.activities_declarations.for_period(@period).first!

          kind        = row[:actividad]
          description = row[:descripcion]
          entity      = row[:entidadcolegio_profesional]
          position    = row[:cargo_o_categoria]
          start_date  = row[:fecha_inicio]
          end_date    = row[:fecha_cese]

          puts "#{@period} - Importing private activity for #{person.name} (#{entity}, #{position}, #{start_date}, #{end_date})"
          declaration.add_private_activity(kind, description, entity, position, start_date, end_date)
          declaration.save!
        end
      end
    end
  end
end
