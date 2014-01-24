# encoding: utf-8

require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$:.unshift(File.join(File.dirname(__FILE__), './lib'))
require 'csl/version'


desc 'Run an IRB session with CSL loaded'
task :console, [:script] do |t,args|
  ARGV.clear

  require 'irb'
  require 'irb/completion'
  require 'csl'

  IRB.conf[:SCRIPT] = args.script
  IRB.start
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |t|
  t.profile = 'default'
end

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, :cucumber, 'coveralls:push']

task :release do |t|
  system "gem build csl.gemspec"
  system "git tag #{CSL::VERSION}"
  system "git push --tags"
  system "gem push csl-#{CSL::VERSION}.gem"
end

task :default => [:spec, :cucumber]

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError => e
  # ignore
end
