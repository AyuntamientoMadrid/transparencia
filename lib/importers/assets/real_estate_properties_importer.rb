require 'importers/year_importer'

module Importers
  module Assets
    class RealEstatePropertiesImporter < YearImporter
      def import!
        each_row do |row|
          begin
            person = Person.find_by!(councillor_code: row[:codigopersona])
            declaration = person.assets_declarations.for_year(@year).first!

            kind           = row[:clase]
            type           = row[:tipo_de_derecho]
            description    = row[:titulo_de_adquisicion]
            municipality   = row[:municipio]
            share          = row[:_participacion]
            purchase_date  = row[:fecha_de_adquisicion]
            tax_value      = row[:valor_catastral]
            notes          = row[:observaciones]

            puts "#{@year} - Importing real estate property for #{person.name} (#{kind}, #{description}, #{municipality})"
            declaration.add_real_estate_property(kind, type, description, municipality, share, purchase_date, tax_value, notes)
            declaration.save!
          rescue
            puts "NOT IMPORTED PERSON #{person.name}:#{person.id}"
          end
        end
      end
    end
  end
end
