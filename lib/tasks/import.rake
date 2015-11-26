require 'importers/people_importer'

namespace :import do
  desc "Imports data/people.csv into the people table"
  task people: :environment do
    Importers::PeopleImporter.new('./data/people.csv').import!
  end
end
