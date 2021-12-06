require "inst-jobs"
require "sentry-ruby"
require "sentry/integrable"
require "sentry/inst_jobs/configuration"
require "sentry/inst_jobs/version"
require "sentry/inst_jobs/plugin"

module Sentry
  module InstJobs
    extend Sentry::Integrable

    register_integration name: "inst_jobs", version: Sentry::InstJobs::VERSION
  end
end
