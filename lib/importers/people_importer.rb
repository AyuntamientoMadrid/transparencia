require 'importers/base_importer'

module Importers
  class PeopleImporter < BaseImporter
    def import!
      each_row do |row|
        puts row.inspect
      end
    end
  end
end
