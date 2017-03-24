require 'factory_girl_rails'
require 'database_cleaner'
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.include FactoryGirl::Syntax::Methods
  config.include CommonActions, :type => :feature
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

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
    unless example.metadata[:clean_as_group]
      DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
      DatabaseCleaner.start
    end
    I18n.default_locale = :en
  end

  config.after(:each) do |example|
    unless example.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end

  config.before(:all) do |example|
    if self.class.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end

  config.after(:all) do |example|
    if self.class.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end

end
