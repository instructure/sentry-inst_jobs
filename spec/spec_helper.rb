require "bundler/setup"
require "pry"

require "active_record"
require "inst-jobs"

require "sentry-ruby"
require "sentry-inst_jobs"

DUMMY_DSN = 'http://12345:67890@sentry.localdomain/sentry/42'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    # Make sure we reset the env in case something leaks in
    ENV.delete('SENTRY_DSN')
    ENV.delete('SENTRY_CURRENT_ENV')
    ENV.delete('SENTRY_ENVIRONMENT')
    ENV.delete('SENTRY_RELEASE')
    ENV.delete('RACK_ENV')
  end
end

# This connection will do for database-independent bug reports.
ENV["TEST_DB_HOST"] ||= "localhost"
ENV["TEST_DB_DATABASE"] ||= "sentry-inst-jobs-test"

connection_config = {
  adapter: :postgresql,
  host: ENV["TEST_DB_HOST"].presence,
  encoding: "utf8",
  username: ENV["TEST_DB_USERNAME"],
  database: ENV["TEST_DB_DATABASE"]
}

ActiveRecord::Base.establish_connection(connection_config.merge(database: "postgres"))
# ActiveRecord::Base.logger = Logger.new(STDOUT)

def build_exception
  1 / 0
rescue ZeroDivisionError => e
  e
end

def perform_basic_setup
  Sentry.init do |config|
    config.dsn = DUMMY_DSN
    config.logger = ::Logger.new(nil)
    config.background_worker_threads = 0
    config.transport.transport_class = Sentry::DummyTransport
    yield(config) if block_given?
  end
end
