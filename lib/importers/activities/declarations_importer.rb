require 'importers/base_importer'

module Importers
  module Activities
    class DeclarationsImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration_date = parse_spanish_date(row[:fecha_de_declaracion])
          begin
            declaration = person.activities_declarations.find_or_create_by!(declaration_date: declaration_date)
            puts("Importing activities declaration for #{person.name}, (#{declaration.declaration_date})")
          rescue ActiveRecord::RecordInvalid => e
            puts("!! Error importing activities declaration for #{person.name}: (#{e})")
          end
        end
      end
    end
  end
end