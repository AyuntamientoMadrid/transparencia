require 'importers/base_importer'

module Importers
  class PublicWorkersImporter < BaseImporter
    def import!
      each_row(col_sep: ";") do |row|
        worker = Person.find_or_initialize_by(personal_code: row[:numper])
        puts "#{worker.persisted? ? 'Updating' : 'Creating'} Public Worker: #{row[:numper]}"
        worker.job_level = 'public_worker'
        worker.first_name = row[:nombre]
        worker.last_name = row[:apellido] + ' ' + row[:segundo_apellido]
        worker.email = row[:correoe]
        worker.role = row[:puesto_especifico]
        worker.unit = row[:unidad_organizativa]
        worker.save!
      end
    end
  end
end
