require 'database_cleaner'

namespace :db do
  namespace :danger do
    desc "Erase the database"
    task truncate: :environment do
      DatabaseCleaner.clean_with :truncation
    end
  end
end
