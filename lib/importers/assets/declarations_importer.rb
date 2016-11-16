require 'importers/period_importer'

module Importers
  module Assets
    class DeclarationsImporter < PeriodImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration_date = parse_declaration_date(row[:fecha_de_declaracion])
          declaration = person.assets_declarations.find_or_create_by!(period: @period, declaration_date: declaration_date)
          puts("Importing assets declaration for #{person.name}, #{@period} (#{declaration.declaration_date})")
        end
      end
    end
  end
end
