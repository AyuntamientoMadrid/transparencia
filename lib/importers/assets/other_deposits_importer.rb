require 'importers/base_importer'

module Importers
  module Assets
    class OtherDepositsImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.assets_declarations.last!

          kind           = row[:clase]
          description    = row[:descripcion]
          amount         = row[:numero_cuantia_o_valor_en_euros]
          purchase_date  = row[:fecha_de_adquisicion]

          unless declaration.has_other_deposit?(kind, description, amount, purchase_date)
            puts "Importing other deposit for #{person.name} (#{kind}, #{description}, #{amount})"
            declaration.add_other_deposit(kind, description, amount, purchase_date)
            declaration.save!
          end
        end
      end
    end
  end
end
