require 'rake'
require 'rake/testtask'

Rake::TestTask.new('spec') do |t|
  t.libs << 'spec'
  t.pattern = "spec/*_spec.rb"
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "shhh #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
