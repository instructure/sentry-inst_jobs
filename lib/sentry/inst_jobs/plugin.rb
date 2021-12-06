# frozen_string_literal: true
require "inst-jobs"

module Sentry
  module InstJobs
    class Plugin < ::Delayed::Plugin
      # need to symbolize strings as keyword arguments in Ruby 2.4~2.6
      INST_JOBS_CONTEXT_KEY = :"Inst-Jobs"

      callbacks do |lifecycle|
        lifecycle.around(:invoke_job) do |job, *args, &block|
          next block.call(job, *args) unless Sentry.initialized?

          Sentry.with_scope do |scope|
            contexts = generate_contexts(job)
            scope.set_transaction_name(contexts.dig(INST_JOBS_CONTEXT_KEY, :job_class))
            scope.set_contexts(**contexts)
            scope.set_tags("inst_jobs.queue" => job.queue, "inst_jobs.id" => job.id.to_s)

            transaction = Sentry.start_transaction(name: scope.transaction_name, op: "inst_jobs")
            scope.set_span(transaction) if transaction

            begin
              block.call(job, *args)

              finish_transaction(transaction, 200)
            rescue Exception => e
              capture_exception(e, job)
              finish_transaction(transaction, 500)
              raise
            end
          end
        end
      end

      def self.generate_contexts(job)
        context = {}

        context[INST_JOBS_CONTEXT_KEY] = {
          id: job.id.to_s,
          priority: job.priority,
          attempts: job.attempts,
          run_at: job.run_at,
          locked_at: job.locked_at,
          locked_by: job.locked_by,
          queue: job.queue,
          created_at: job.created_at,
          last_error: job.last_error&.byteslice(0..1000),
          handler: job.handler&.byteslice(0..1000),
          job_class: compute_job_class(job.payload_object),
        }

        context
      end

      def self.compute_job_class(payload_object)
        if payload_object.is_a? Delayed::PerformableMethod
          klass = payload_object.object.is_a?(Class) ? payload_object.object.name : payload_object.object.class.name
          "#{klass}##{payload_object.method}"
        else
          payload_object.class.name
        end
      end

      def self.capture_exception(exception, job)
        Sentry::InstJobs.capture_exception(exception, hint: { background: false }) if report?(job)
      end

      def self.report?(job)
        return true unless Sentry.configuration.inst_jobs.report_after_job_retries

        # We use the predecessor because the job's attempts haven't been increased to the new
        # count at this point.
        job.attempts >= job.max_attempts.pred
      end

      def self.finish_transaction(transaction, status)
        return unless transaction
  
        transaction.set_http_status(status)
        transaction.finish
      end
    end
  end
end

Delayed::Worker.plugins << Sentry::InstJobs::Plugin
