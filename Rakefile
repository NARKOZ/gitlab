require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern    = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['--color', '--format d']
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = false
  task.options = ['-D', '--parallel']
end

if ENV['TRAVIS_CI_RUBOCOP']
  task default: :rubocop
else
  task default: :spec
end
