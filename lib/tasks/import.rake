require 'importers/people_importer'
require 'importers/parties_importer'

namespace :import do
  desc "Imports data/parties.csv into the parties table"
  task parties: :environment do
    Importers::PartiesImporter.new('./import-data/parties.csv').import!
  end

  desc "Imports data/people.csv into the people table"
  task people: :environment do
    Importers::PeopleImporter.new('./import-data/people.csv').import!
  end
end
