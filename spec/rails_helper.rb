ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'devise'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

include ActionView::Helpers::NumberHelper
include Warden::Test::Helpers
Warden.test_mode!

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include Devise::TestHelpers, type: :controller
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    timeout: 1.minute,
    inspector: true, # allows remote debugging by executing page.driver.debug
    phantomjs_logger: File.open(File::NULL, "w"), # don't print console.log calls in console
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    extensions: [File.expand_path("../support/phantomjs_ext/disable_js_fx.js", __FILE__)] # disable js effects
  )
end

Capybara.javascript_driver = :poltergeist
Capybara.exact = true
