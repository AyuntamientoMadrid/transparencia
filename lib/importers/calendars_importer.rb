module Importers
  class CalendarsImporter < BaseImporter
    def import!
      each_row do |row|
        admin_last_name = transliterate(row[:apellidos])
        admin_first_name = transliterate(row[:nombre])

        person = Person.where("admin_first_name = ? AND admin_last_name = ?", admin_first_name, admin_last_name).first
        if person
          puts "Importing calendar for #{person.name}"
          person.update(calendar_url: row[:url_publica])
        else
          puts "-------------------------"
          puts "PERSON MISSING FOR CALENDAR: #{admin_first_name} #{admin_last_name}"
        end
      end
    end
  end
end
