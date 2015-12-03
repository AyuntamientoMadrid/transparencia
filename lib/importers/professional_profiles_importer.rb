module Importers
  class ProfessionalProfilesImporter < BaseImporter

    def import!
      each_row(col_sep: ";") do |row|
        # person = find with nombre, apellidos, o n_personal
        # party = find by row[:unidad]

        puts [row[:nombre], row[:apellidos], row[:cargo], row[:unidad], row[:n_personal]].join(',')
      end
    end

  end
end
