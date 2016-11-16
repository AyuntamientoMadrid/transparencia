require 'importers/base_importer'

module Importers
  class PeriodImporter < BaseImporter
    def initialize(period, path_to_file)
      super(path_to_file)
      @period = period
    end
  end
end
