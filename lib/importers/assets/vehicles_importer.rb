require 'importers/period_importer'

module Importers
  module Assets
    class VehiclesImporter < PeriodImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.assets_declarations.for_period(@period).first!

          kind           = row[:clase]
          model          = row[:marca_y_modelo]
          purchase_date  = row[:fecha_de_adquisicion]

          puts "#{@period} - Importing vehicle for #{person.name} (#{kind}, #{model})"
          declaration.add_vehicle(kind, model, purchase_date)
          declaration.save!
        end
      end
    end
  end
end
