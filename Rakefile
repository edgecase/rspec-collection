#!/usr/bin/ruby -wKU

require './lib/rspec-collection/version'

$package_version = RSpecCollection::VERSION

task :default => :spec

task :spec do
  sh "rspec -Ilib spec"
end
