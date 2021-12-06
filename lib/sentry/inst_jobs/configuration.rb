module Sentry
  class Configuration
    attr_reader :inst_jobs

    add_post_initialization_callback do
      @inst_jobs = Sentry::InstJobs::Configuration.new
    end
  end

  module InstJobs
    class Configuration
      # Set this option to true if you want Sentry to only capture the last job
      # retry if it fails.
      attr_accessor :report_after_job_retries

      def initialize
        @report_after_job_retries = false
      end
    end
  end
end
