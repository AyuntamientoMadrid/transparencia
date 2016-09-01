require 'importers/parties_importer'
require 'importers/councillors_importer'
require 'importers/profiles_importer'
require 'importers/non_profiles_importer'
require 'importers/calendars_importer'
require 'importers/assets/declarations_importer'
require 'importers/assets/account_deposits_importer'
require 'importers/assets/real_estate_properties_importer'
require 'importers/assets/other_deposits_importer'
require 'importers/assets/vehicles_importer'
require 'importers/assets/other_personal_properties_importer'
require 'importers/assets/debts_importer'
require 'importers/activities/declarations_importer'
require 'importers/activities/public_importer'
require 'importers/activities/private_importer'
require 'importers/activities/other_importer'
require 'importers/contracts_importer'
require 'importers/subventions_importer'

namespace :import do
  desc "Imports import-data/parties.csv into the parties table"
  task parties: :environment do
    Importers::PartiesImporter.new('./import-data/parties.csv').import!
  end

  desc "Imports import-data/councillors.csv into the people table"
  task councillors: 'import:parties' do
    Importers::CouncillorsImporter.new('./import-data/councillors.csv').import!
  end

  desc "Imports import-data/PerfilProfesional.csv into the people table"
  task profiles: 'import:councillors' do
    Importers::ProfilesImporter.new('./import-data/profiles.csv').import!
    Importers::NonProfilesImporter.new('./import-data/non-profiles.csv').import!
  end

  desc "Imports import-data/calendars.csv into the db"
  task calendars: 'import:profiles' do
    Importers::CalendarsImporter.new('./import-data/calendars.csv').import!
  end

  namespace :assets do
    desc "Imports import-data/assets/assets_declarations.csv into assets_declarations table"
    task :declarations, [:year] => 'import:councillors' do |t, args|
      Importers::Assets::DeclarationsImporter.new("./import-data/#{args[:year]}/assets/assets_declarations.csv").import!
    end

    desc "Imports import-data/assets/real_estate_properties.csv into the assets_declaration table"
    task :real_estate_properties, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::RealEstatePropertiesImporter.new("./import-data/#{args[:year]}/assets/real_estate_properties.csv").import!
    end

    desc "Imports import-data/assets/account_deposits.csv into the assets_declaration table"
    task :account_deposits, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::AccountDepositsImporter.new("./import-data/#{args[:year]}/assets/account_deposits.csv").import!
    end

    desc "Imports import-data/assets/other_deposits.csv into the assets_declaration table"
    task :other_deposits, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::OtherDepositsImporter.new("./import-data/#{args[:year]}/assets/other_deposits.csv").import!
    end

    desc "Imports import-data/assets/vehicles.csv into the assets_declaration table"
    task :vehicles, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::VehiclesImporter.new("./import-data/#{args[:year]}/assets/vehicles.csv").import!
    end

    desc "Imports import-data/assets/other_personal_properties.csv into the assets_declaration table"
    task :other_personal_properties, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::OtherPersonalPropertiesImporter.new("./import-data/#{args[:year]}/assets/other_personal_properties.csv").import!
    end

    desc "Imports import-data/assets/debts.csv into the assets_declaration table"
    task :debts, [:year] => 'import:assets:declarations' do |t, args|
      Importers::Assets::DebtsImporter.new("./import-data//#{args[:year]}/assets/debts.csv").import!
    end

    desc "Imports all the information about assets_declarations"
    task :all, [:year] => ['import:assets:declarations',
                           'import:assets:real_estate_properties',
                           'import:assets:account_deposits',
                           'import:assets:other_deposits',
                           'import:assets:vehicles',
                           'import:assets:other_personal_properties',
                           'import:assets:debts']
  end

  namespace :activities do
    desc "Imports import-data/activities/activities_declarations.csv into activities_declarations table"
    task declarations: 'import:councillors' do
      Importers::Activities::DeclarationsImporter.new('./import-data/activities/activities_declarations.csv').import!
    end

    desc "Imports import-data/activities/public_activities.csv into the activities_declarations table"
    task public: 'import:activities:declarations' do
      Importers::Activities::PublicImporter.new('./import-data/activities/public_activities.csv').import!
    end

    desc "Imports import-data/activities/private_activities.csv into the activities_declarations table"
    task private: 'import:activities:declarations' do
      Importers::Activities::PrivateImporter.new('./import-data/activities/private_activities.csv').import!
    end

    desc "Imports import-data/activities/other_activities.csv into the activities_declarations table"
    task other: 'import:activities:declarations' do
      Importers::Activities::OtherImporter.new('./import-data/activities/other_activities.csv').import!
    end

    desc "Imports all the information about activities_declarations"
    task all: ['import:activities:declarations',
               'import:activities:public',
               'import:activities:private',
               'import:activities:other']
  end

  desc "Imports import-data/contracts/contratos_formalizados_agosto_2015.csv into the contracts table"
  task contracts: :environment do
    Importers::ContractsImporter.new('./import-data/contracts/contratos_formalizados_agosto_2015.csv').import!
  end

  desc "Imports import-data/subventions/cooperacion_v1.csv into the subventions table"
  task subventions: :environment do
    Importers::SubventionsImporter.new('./import-data/subventions/cooperacion_v1.csv').import!
  end

end
