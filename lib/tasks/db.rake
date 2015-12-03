require 'database_cleaner'

namespace :db do
  namespace :danger do
    desc "Erase the database"
    task truncate: :environment do
      DatabaseCleaner.clean_with :truncation
    end
  end

  desc "Resets the database and loads it from db/dev_seeds.rb"
  task dev_seed: :environment do
    load(Rails.root.join("db", "dev_seeds.rb"))
  end
end