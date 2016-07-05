module Importers
  class NonProfilesImporter < BaseImporter

    JOB_LEVEL_CODES = {
      'Concejal'=> 'councillor',
      'Directivo' => 'director',
      'Eventual' => 'temporary_worker'
    }

    def import!
      each_row do |row|
        person = Person.where(admin_first_name: transliterate(row[:nombre]),
                              admin_last_name: transliterate(row[:apellidos])).first_or_initialize
        person.first_name ||= row[:nombre]
        person.last_name  ||= row[:apellidos]
        puts "Importing non-profile for #{person.name}"
        person.role      = row[:cargo]
        person.job_level = JOB_LEVEL_CODES[row[:tipo_de_cargo]]
        person.unit      = row[:unidad]
        person.save!
      end
    end
  end
end
