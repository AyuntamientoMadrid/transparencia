module Importers
  class CalendarsImporter < BaseImporter
    def import!
      each_row do |row|
        admin_name = row[:titular].split(', ')
        admin_first_name = transliterate(admin_name.last)
        admin_last_name = transliterate(admin_name.first) # not an error, the csv has the names switched

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
