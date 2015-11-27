require 'importers/base_importer'

module Importers
  class AssetsDeclarationsImporter < BaseImporter
    def import!
      each_row do |row|
        person = Person.find_by!(internal_code: row[:codigopersona])
        declaration_date = parse_declaration_date(row[:fecha_de_declaracion])
        declaration = person.assets_declarations.find_or_create_by!(declaration_date: declaration_date)
        puts("Importing assets declaration for #{person.name}, (#{declaration.declaration_date})")
      end
    end
  end
end
