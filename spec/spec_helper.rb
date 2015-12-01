require 'factory_girl_rails'
require 'database_cleaner'
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.include FactoryGirl::Syntax::Methods
  config.include CommonActions, :type => :feature

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  ## Used only for travis until we release on the 10th of december.
  config.before(:each) do
    allow_any_instance_of(ApplicationController).
    to receive(:allow_wip_access?).and_return(true)
  end

end
