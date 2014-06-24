# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
ENV["DATABASE_URL"] = 'postgres://localhost/evercam_tst'
ENV["RACK_ENV"]  = ENV["RAILS_ENV"]
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl'
require 'rack_session_access/capybara'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

require 'database_cleaner'
require 'capybara/rails'
require 'simplecov'

SimpleCov.start 'rails'

#Capybara.server_port = 3001
#Capybara.app_host = "http://local.evercam.io:3001"

#ActionController::Base.asset_host = Capybara.app_host

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
#ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = "random"
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # Configure factory girl stuff.
  config.include FactoryGirl::Syntax::Methods

  # Configure database cleaner.
  config.before(:suite) do
    WebMock.disable_net_connect!(:allow_localhost => true)
    DatabaseCleaner[:sequel].strategy = :truncation, {except: %w[spatial_ref_sys]}
    DatabaseCleaner[:sequel].clean_with(:truncation, except: %w[spatial_ref_sys])
  end

  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end

# Load up factories.
FactoryGirl.find_definitions
