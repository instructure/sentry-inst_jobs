require "spec_helper"

RSpec.describe Sentry::InstJobs::Configuration do
  it "adds #inst_jobs option to Sentry::Configuration" do
    config = Sentry::Configuration.new

    expect(config.inst_jobs).to be_a(described_class)
  end

  describe "#report_after_job_retries" do
    it "has correct default value" do
      expect(subject.report_after_job_retries).to eq(false)
    end
  end
end
