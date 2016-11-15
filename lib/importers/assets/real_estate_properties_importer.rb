require 'importers/period_importer'

module Importers
  module Assets
    class RealEstatePropertiesImporter < PeriodImporter
      def import!
        each_row do |row|
          person = Person.find_by!(councillor_code: row[:codigopersona])
          declaration = person.assets_declarations.for_period(@period).first!

          kind           = row[:clase]
          type           = row[:tipo_de_derecho]
          description    = row[:titulo_de_adquisicion]
          municipality   = row[:municipio]
          share          = row[:_participacion]
          purchase_date  = row[:fecha_de_adquisicion]
          tax_value      = row[:valor_catastral]
          notes          = row[:observaciones]

          puts "#{@period} - Importing real estate property for #{person.name} (#{kind}, #{description}, #{municipality})"
          declaration.add_real_estate_property(kind, type, description, municipality, share, purchase_date, tax_value, notes)
          declaration.save!
        end
      end
    end
  end
end
