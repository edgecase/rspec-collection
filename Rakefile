#!/usr/bin/ruby -wKU

require 'rake/clean'
require './lib/rspec-collection/version'

CLOBBER.include('*.gemspec')

Project = OpenStruct.new(
  :name => "rspec-collection",
  :version => RSpecCollection::VERSION,
  :author => "Jim Weirich",
  :author_email => "jim@edgecase.com",
  :home_page => "http://github.com/jimweirich/rspec-collection")

task :default => :spec

task :spec do
  sh "rspec -Ilib spec"
end
