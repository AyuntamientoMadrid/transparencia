require 'importers/people_importer'
require 'importers/parties_importer'
require 'importers/account_deposits_importer'
require 'importers/assets_declarations_importer'

namespace :import do
  desc "Imports import-data/parties.csv into the parties table"
  task parties: :environment do
    Importers::PartiesImporter.new('./import-data/parties.csv').import!
  end

  desc "Imports import-data/people.csv into the people table"
  task people: :environment do
    Importers::PeopleImporter.new('./import-data/people.csv').import!
  end

  desc "Imports import-data/assets/assets_declarations.csv into assets_declarations table"
  task assets_declarations: :environment do
    Importers::AssetsDeclarationsImporter.new('./import-data/assets/assets_declarations.csv').import!
  end

end
