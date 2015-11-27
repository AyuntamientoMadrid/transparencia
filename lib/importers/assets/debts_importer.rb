require 'importers/base_importer'

module Importers
  module Assets
    class DebtsImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.assets_declarations.last!

          kind           = row[:clase]
          amount         = row[:importe_actual_en_euros]
          comments       = row[:observaciones]
          comments = nil if comments.is_a?(String) && comments.length <= 3

          unless declaration.has_debt?(kind, amount, comments)
            puts "Importing debt for #{person.name} (#{kind}, #{amount}, #{comments})"
            declaration.add_debt(kind, amount, comments)
            declaration.save!
          end
        end
      end
    end
  end
end
