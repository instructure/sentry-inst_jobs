require "bundler/gem_tasks"
require "logger"
require "rspec/core/rake_task"

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

RSpec::Core::RakeTask.new(:spec).tap do |task|
  task.rspec_opts = "--order rand"
end

task :default => :spec
