source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use PostgreSQL
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'foundation-rails', '5.5.1' # 5.5.3 has a js problem: https://github.com/zurb/foundation-sites/issues/8416
gem 'foundation_rails_helper'
gem 'trix'
gem 'ancestry'
gem 'devise'
gem 'groupdate'
gem 'kaminari'
gem 'unicorn', '~> 5.0.1'
gem 'friendly_id', '~> 5.1.0'
gem 'dalli'
gem 'rollbar', '~> 2.8.3'
gem 'newrelic_rpm', '~> 3.14'
gem 'rinku', require: 'rails_rinku'
gem 'roo'
gem 'roo-xls'
gem 'spreadsheet'
gem 'whenever', require: false

# For rake db:danger:truncate
gem 'database_cleaner'

gem 'pg_search'
gem 'turnout'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'launchy'
  gem 'quiet_assets'
  gem 'i18n-tasks'

  gem 'capistrano', '3.4.0',           require: false
  gem "capistrano-bundler", '1.1.4',   require: false
  gem "capistrano-rails", '1.1.6',     require: false
  gem "capistrano-rvm",                require: false
  gem "capistrano-rake",               require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
end

group :test do
  gem 'poltergeist'
end
