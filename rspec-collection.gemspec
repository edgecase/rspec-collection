--- !ruby/object:Gem::Specification 
name: rspec-collection
version: !ruby/object:Gem::Version 
  prerelease: false
  segments: 
  - 2
  - 0
  - 0
  version: 2.0.0
platform: ruby
authors: 
- Jim Weirich
autorequire: 
bindir: bin
cert_chain: []

date: 2010-10-12 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: rspec-core
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        segments: 
        - 2
        - 0
        - 0
        version: 2.0.0
  type: :runtime
  version_requirements: *id001
description: "      For example:\n\n        collection.should all_be > 0\n\n      will specify that each element of the collection should be greater\n      than zero.  Each element of the collection that fails the test will\n      be reported in the error message.\n"
email: jim@edgecase.com
executables: []

extensions: []

extra_rdoc_files: 
- README.md
files: 
- lib/rspec-collection/all_be.rb
- spec/rspec-collection/all_be_spec.rb
- spec/spec_helper.rb
- Rakefile
- rakelib/gem.rake
- README.md
has_rdoc: true
homepage: http://github.com/jimweirich/rspec-collection
licenses: []

post_install_message: 
rdoc_options: 
- ""
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: 
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Allow RSpec assertions over the elements of a collection.
test_files: []

