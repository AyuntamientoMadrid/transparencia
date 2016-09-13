require 'importers/year_importer'

module Importers
  module Assets
    class DebtsImporter < YearImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.assets_declarations.for_year(@year).first!

          kind           = row[:clase]
          amount         = row[:importe_actual_en_euros]
          comments       = row[:observaciones]

          puts "#{@year} - Importing debt for #{person.name} (#{kind}, #{amount}, #{comments})"
          declaration.add_debt(kind, amount, comments)
          declaration.save!
        end
      end
    end
  end
end
