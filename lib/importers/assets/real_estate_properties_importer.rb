require 'importers/base_importer'

module Importers
  module Assets
    class RealEstatePropertiesImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.assets_declarations.last!

          kind           = row[:clase]
          type           = row[:tipo_de_derecho]
          description    = row[:titulo_de_adquisicion]
          municipality   = row[:municipio]
          share          = row[:_participacion]
          purchase_date  = parse_spanish_date(row[:fecha_de_adquisicion])
          tax_value      = parse_amount(row[:valor_catastral])

          unless declaration.has_real_estate_property?(kind, type, description, municipality, share, purchase_date, tax_value)
            puts "Importing real estate property for #{person.name} (#{kind}, #{description}, #{municipality})"
            declaration.add_real_estate_property(kind, type, description, municipality, share, purchase_date, tax_value)
            declaration.save!
          end
        end
      end
    end
  end
end
