require 'importers/base_importer'

module Importers
  module Assets
    class VehiclesImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.assets_declarations.last!

          kind           = row[:clase]
          model          = row[:marca_y_modelo]
          purchase_date  = parse_spanish_date(row[:fecha_de_adquisicion])

          unless declaration.has_vehicle?(kind, model, purchase_date)
            puts "Importing vehicle for #{person.name} (#{kind}, #{model})"
            declaration.add_vehicle(kind, model, purchase_date)
            declaration.save!
          end
        end
      end
    end
  end
end
