require 'importers/year_importer'

module Importers
  module Assets
    class OtherDepositsImporter < YearImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.assets_declarations.for_year(@year).first!

          kind           = row[:clase]
          description    = row[:descripcion]
          amount         = row[:numero_cuantia_o_valor_en_euros]
          purchase_date  = row[:fecha_de_adquisicion]

          puts "#{@year} - Importing other deposit for #{person.name} (#{kind}, #{description}, #{amount})"
          declaration.add_other_deposit(kind, description, amount, purchase_date)
          declaration.save!
        end
      end
    end
  end
end
