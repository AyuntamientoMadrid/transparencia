require 'importers/base_importer'

module Importers
  module Assets
    class OtherPersonalPropertiesImporter < BaseImporter
      def import!
        each_row do |row|
          person = Person.find_by!(internal_code: row[:codigopersona])
          declaration = person.assets_declarations.last!

          kind           = row[:clase]
          purchase_date  = row[:fecha_de_adquisicion]

          puts "Importing other personal properties for #{person.name} (#{kind})"
          declaration.add_other_personal_property(kind, purchase_date)
          declaration.save!
        end
      end
    end
  end
end
