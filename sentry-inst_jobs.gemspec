require_relative "lib/sentry/inst_jobs/version"

Gem::Specification.new do |spec|
  spec.name          = "sentry-inst_jobs"
  spec.version       = Sentry::InstJobs::VERSION
  spec.authors = ["Isaac Moore"]
  spec.description = spec.summary = "An inst-jobs integration for the Sentry error logger"
  spec.email = "isaac.moore@instructure.com"
  spec.license = 'MIT'
  spec.homepage = "https://github.com/instructure/sentry-inst_jobs"

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.4'
  spec.extra_rdoc_files = %w[README.md LICENSE]
  spec.files = `git ls-files | grep -Ev '^(spec|benchmarks|examples)'`.split("\n")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sentry-ruby-core", "~> 5.1.0"
  spec.add_dependency "inst-jobs", "~> 3.0"
end
