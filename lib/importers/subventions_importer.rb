require 'importers/base_importer'

module Importers
  class SubventionsImporter < BaseImporter
    def import!
      each_row do |row|
        recipient = row[:ong]
        project = row[:titulo_proyecto]
        kind = row[:tipologia]
        location = row[:pais]
        year = row[:ano_de_ejecucion].to_i
        amount = row[:subvencion_]
        euros, cents = amount.split(',')
        cents ||= "00"
        amount_euro_cents = "#{euros}#{cents}".gsub(/[^0-9]/,'').to_i

        puts "Importing #{year} subvention to: #{recipient} - #{project}"

        Subvention.create! recipient: recipient, project: project, kind: kind, location: location, year: year, amount_euro_cents: amount_euro_cents
      end
    end
  end
end
