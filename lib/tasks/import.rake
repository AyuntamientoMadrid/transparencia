require 'importers/people_importer'
require 'importers/parties_importer'
require 'importers/account_deposits_importer'
require 'importers/real_estate_properties_importer'
require 'importers/assets_declarations_importer'
require 'importers/other_deposits_importer'
require 'importers/vehicles_importer'
require 'importers/other_personal_properties_importer'

namespace :import do
  desc "Imports import-data/parties.csv into the parties table"
  task parties: :environment do
    Importers::PartiesImporter.new('./import-data/parties.csv').import!
  end

  desc "Imports import-data/people.csv into the people table"
  task people: 'import:parties' do
    Importers::PeopleImporter.new('./import-data/people.csv').import!
  end

  desc "Imports import-data/assets/assets_declarations.csv into assets_declarations table"
  task assets_declarations: 'import:people' do
    Importers::AssetsDeclarationsImporter.new('./import-data/assets/assets_declarations.csv').import!
  end

  desc "Imports import-data/assets/real_estate_properties.csv into the assets_declaration table"
  task real_estate_properties: 'import:assets_declarations' do
    Importers::RealEstatePropertiesImporter.new('./import-data/assets/real_estate_properties.csv').import!
  end

  desc "Imports import-data/assets/account_deposits.csv into the assets_declaration table"
  task account_deposits: 'import:assets_declarations' do
    Importers::AccountDepositsImporter.new('./import-data/assets/account_deposits.csv').import!
  end

  desc "Imports import-data/assets/other_deposits.csv into the assets_declaration table"
  task other_deposits: 'import:assets_declarations' do
    Importers::OtherDepositsImporter.new('./import-data/assets/other_deposits.csv').import!
  end

  desc "Imports import-data/assets/vehicles.csv into the assets_declaration table"
  task vehicles: 'import:assets_declarations' do
    Importers::VehiclesImporter.new('./import-data/assets/vehicles.csv').import!
  end

  desc "Imports import-data/assets/other_personal_properties.csv into the assets_declaration table"
  task other_personal_properties: 'import:assets_declarations' do
    Importers::OtherPersonalPropertiesImporter.new('./import-data/assets/other_personal_properties.csv').import!
  end
end
