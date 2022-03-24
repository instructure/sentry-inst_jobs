require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'sentry-inst_jobs'

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('..', __dir__)
    config.active_record.dump_schema_after_migration = false
  end
end
