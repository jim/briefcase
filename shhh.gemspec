Gem::Specification.new do |s|
  s.name = %q{shhh}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Benton"]
  s.date = %q{2010-11-22}
  s.default_executable = %q{shhh}
  s.description = %q{Command line program to migrate dotfiles to a git repo at ~/.dotfiles and generate static dotfiles with secret values.}
  s.email = %q{jim@autonomousmachine.com}
  s.executables = ["shhh"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/shhh",
     "lib/shhh.rb",
     "lib/shhh/commands.rb",
     "lib/shhh/commands/base.rb",
     "lib/shhh/commands/import.rb",
     "lib/shhh/commands/sync.rb",
     "lib/shhh/main.rb",
     "shhh.gemspec",
     "spec/bin/editor",
     "spec/helpers/assertions.rb",
     "spec/helpers/commands.rb",
     "spec/helpers/files.rb",
     "spec/helpers/stubbing.rb",
     "spec/import_spec.rb",
     "spec/spec_helper.rb",
     "spec/sync_spec.rb"
  ]
  s.homepage = %q{http://github.com/jim/shhh}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Shhh manages dotfiles and handles keeping their secrets safe}
  s.test_files = [
    "spec/helpers/assertions.rb",
     "spec/helpers/commands.rb",
     "spec/helpers/files.rb",
     "spec/helpers/stubbing.rb",
     "spec/import_spec.rb",
     "spec/spec_helper.rb",
     "spec/sync_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
    else
      s.add_dependency(%q<commander>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<commander>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
  end
end

