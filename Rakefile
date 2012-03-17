# encoding: utf-8

require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require "rake"

require "jeweler"
Jeweler::Tasks.new do |gem|
  gem.name                  = "jaRL"
  gem.homepage              = "http://github.com/jacksonwillis/jaRL"
  gem.license               = "MIT"
  gem.summary               = "just another Ruby Lisp ツ"
  gem.description           = "a Lisp dialect with access to Ruby libraries"
  gem.required_ruby_version = "1.9.2"
  gem.email                 = "railsmail42@gmail.com"
  gem.authors               = ["Jackson Willis"]
end
Jeweler::RubygemsDotOrgTasks.new

require "rspec/core"
require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList["spec/**/*_spec.rb"]
end

task :default => :spec
