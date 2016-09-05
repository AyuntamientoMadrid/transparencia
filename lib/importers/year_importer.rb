require 'importers/base_importer'

module Importers
  class YearImporter < BaseImporter
    def initialize(year, path_to_file)
      super(path_to_file)
      @year = year
    end
  end
end
