require 'importers/base_importer'

module Importers
  class SubventionsImporter < BaseImporter
    def import!
      each_row do |row|
        recipient = parse_text(row[:ong])
        project = parse_text(row[:titulo_proyecto])
        kind = row[:tipologia]
        location = parse_text(row[:pais])
        year = row[:ano_de_ejecucion].to_i
        amount = row[:subvencion_]
        euros, cents = amount.split(',')
        cents ||= "00"
        amount_euro_cents = "#{euros}#{cents}".gsub(/[^0-9]/,'').to_i

        puts "Importing #{year} subvention to: #{recipient} - #{project}"

        subvention = Subvention.find_or_initialize_by(project: project, recipient: recipient, year: year)
        subvention.attributes = { recipient: recipient, project: project, kind: kind, location: location, year: year, amount_euro_cents: amount_euro_cents }
        subvention.save!
      end
    end
  end
end
