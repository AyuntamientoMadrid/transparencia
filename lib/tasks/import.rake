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

require 'excel_importers/profile'

namespace :import do
  desc "Imports everything"
  task all: ['import:calendars', 'import:assets:all', 'import:activities:all']

  desc "Imports import-data/parties.csv into the parties table"
  task parties: :environment do
    Importers::PartiesImporter.new('./import-data/parties.csv').import!
  end

  desc "Imports import-data/councillors.csv into the people table"
  task councillors: 'import:parties' do
    Importers::CouncillorsImporter.new('./import-data/councillors.csv').import!
  end

  desc "Imports import-data/profiles.csv & non-profiles.csv into the people table"
  task profiles: 'import:councillors' do
    Importers::ProfilesImporter.new('./import-data/profiles.csv').import!
    Importers::NonProfilesImporter.new('./import-data/non-profiles.csv').import!
  end

  desc "Imports import-data/non-profiles.csv into the people table"
  task non_profiles: 'import:councillors' do
    Importers::NonProfilesImporter.new('./import-data/non-profiles.csv').import!
  end

  desc "Imports import-data/calendars.csv into the db"
  task calendars: :environment do
    Importers::CalendarsImporter.new('./import-data/calendars.csv').import!
  end

  namespace :spec do
    desc "Imports import-data/PerfilProfesional.csv into the people table"
    task profiles: 'import:councillors' do

      logger = Logger.new(STDOUT)
      logger.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end
      ExcelImporters::Profile.new('./spec/fixtures/files/profiles.xls', header_field: 'Fecha', logger: logger).import
      Importers::NonProfilesImporter.new('./import-data/non-profiles.csv').import!
    end
  end

  namespace :assets do
    asset_periods = []

    desc "Parses the available asset periods in import-data/assets"
    task :parse_periods do
      asset_periods = Dir.entries('import-data/assets').select { |entry| entry[0] != '.' }
      puts "Assets periods: #{asset_periods}"
    end

    desc "Imports import-data/assets/[period]/1_datos_personales.csv into assets_declarations table"
    task :declarations => ['import:councillors', 'import:assets:parse_periods'] do
      asset_periods.each do |period|
        Importers::Assets::DeclarationsImporter.new(period, "./import-data/assets/#{period}/1_datos_personales.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/3_patrimonio_inmobiliario.csv into the assets_declaration table"
    task :real_estate_properties => 'import:assets:declarations' do
      asset_periods.each do |period|
        Importers::Assets::RealEstatePropertiesImporter.new(period, "./import-data/assets/#{period}/3_patrimonio_inmobiliario.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/4_depositos_en_cuenta.csv into the assets_declaration table"
    task :account_deposits => 'import:assets:declarations' do
      asset_periods.each do |period|
        Importers::Assets::AccountDepositsImporter.new(period, "./import-data/assets/#{period}/4_depositos_en_cuenta.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/5_otros_depositos_en_cuenta.csv into the assets_declaration table"
    task :other_deposits => 'import:assets:declarations' do |t, args|
      asset_periods.each do |period|
        Importers::Assets::OtherDepositsImporter.new(period, "./import-data/assets/#{period}/5_otros_depositos_en_cuenta.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/6_vehiculos.csv into the assets_declaration table"
    task :vehicles => 'import:assets:declarations' do |t, args|
      asset_periods.each do |period|
        Importers::Assets::VehiclesImporter.new(period, "./import-data/assets/#{period}/6_vehiculos.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/7_otros_bienes_muebles.csv into the assets_declaration table"
    task :other_personal_properties => 'import:assets:declarations' do |t, args|
      asset_periods.each do |period|
        Importers::Assets::OtherPersonalPropertiesImporter.new(period, "./import-data/assets/#{period}/7_otros_bienes_muebles.csv").import!
      end
    end

    desc "Imports import-data/assets/[period]/8_deudas.csv into the assets_declaration table"
    task :debts => 'import:assets:declarations' do |t, args|
      asset_periods.each do |period|
        Importers::Assets::DebtsImporter.new(period, "./import-data/assets/#{period}/8_deudas.csv").import!
      end
    end

    desc "Imports all the information about assets_declarations"
    task :all => ['import:assets:declarations',
                  'import:assets:real_estate_properties',
                  'import:assets:account_deposits',
                  'import:assets:other_deposits',
                  'import:assets:vehicles',
                  'import:assets:other_personal_properties',
                  'import:assets:debts']
  end

  namespace :activities do

    activities_periods = []

    desc "Parses the available asset periods in import-data/activities"
    task :parse_periods do
      activities_periods = Dir.entries('import-data/activities').select { |entry| entry[0] != '.' }
      puts "Activities periods: #{activities_periods}"
    end

    desc "Imports import-data/activities/[period]/1_datos_personales.csv into activities_declarations table"
    task declarations: ['import:councillors', 'import:activities:parse_periods'] do
      activities_periods.each do |period|
        Importers::Activities::DeclarationsImporter.new(period, "./import-data/activities/#{period}/1_datos_personales.csv").import!
      end
    end

    desc "Imports import-data/activities/[period]/3_1_puestos_de_trabajo.csv into the activities_declarations table"
    task public: 'import:activities:declarations' do
      activities_periods.each do |period|
        Importers::Activities::PublicImporter.new(period, "./import-data/activities/#{period}/3_1_puestos_de_trabajo.csv").import!
      end
    end

    desc "Imports import-data/activities/[period]/3_2_actividades_privadas.csv into the activities_declarations table"
    task private: 'import:activities:declarations' do
      activities_periods.each do |period|
        Importers::Activities::PrivateImporter.new(period, "./import-data/activities/#{period}/3_2_actividades_privadas.csv").import!
      end
    end

    desc "Imports import-data/activities/[period]/3_3_otras_actividades.csv into the activities_declarations table"
    task other: 'import:activities:declarations' do
      activities_periods.each do |period|
        Importers::Activities::OtherImporter.new(period, "./import-data/activities/#{period}/3_3_otras_actividades.csv").import!
      end
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
