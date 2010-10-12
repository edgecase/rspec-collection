begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end

PKG_FILES = FileList['**/*.rb', 'Rakefile', '**/*.rake', 'README.md']

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  SPEC = Gem::Specification.new do |s|

    #### Basic information.

    s.name = 'rspec-collection'
    s.version = $package_version
    s.summary = "Allow RSpec assertions over the elements of a collection."
    s.description = <<-EOF
      For example:

        collection.should all_be > 0

      will specify that each element of the collection should be greater
      than zero.  Each element of the collection that fails the test will
      be reported in the error message.
    EOF

    #### Dependencies and requirements.

    s.add_dependency('rspec-core', '>= 2.0.0')
    #s.requirements << ""

    s.files = PKG_FILES.to_a
    s.require_path = 'lib'                         # Use these for libraries.

    #### Documentation and testing.

    s.has_rdoc = true
    s.extra_rdoc_files = ["README.md"]
    s.rdoc_options = ""

    #### Author and project details.

    s.author = "Jim Weirich"
    s.email = "jim@edgecase.com"
    s.homepage = "http://github.com/jimweirich/rspec-collection"
    s.rubyforge_project = nil
  end

  Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  file "rspec-collection.gemspec" => ["Rakefile", "rakelib/gem.rake"] do |t|
    require 'yaml'
    open(t.name, "w") { |f| f.puts SPEC.to_yaml }
  end

  desc "Create a stand-alone gemspec"
  task :gemspec => "rspec-collection.gemspec"
end
