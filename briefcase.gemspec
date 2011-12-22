require File.expand_path('lib/briefcase/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{briefcase}
  s.version = Briefcase::VERSION
  s.authors = ["Jim Benton"]
  s.date = %q{2010-12-06}
  s.default_executable = %q{briefcase}
  s.description = %q{Command line program to migrate dotfiles to a git repo at ~/.dotfiles and generate static dotfiles with secret values.}
  s.email = %q{jim@autonomousmachine.com}
  s.executables = ["briefcase"]
  s.extra_rdoc_files = %w{README.rdoc LICENSE}
  s.files = Dir['lib/**/*.rb'] +                      # library
            Dir['bin/*'] +                            # executable
            Dir['spec/**/*.rb'] +                     # spec files
            Dir['spec/bin/editor'] +                  # spec editor
            %w{README.rdoc LICENSE briefcase.gemspec Rakefile}  # misc

  s.homepage = %q{http://github.com/jim/briefcase}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Briefcase manages dotfiles and handles keeping their secrets safe}
  s.test_files = Dir['spec/*.rb']

  s.add_runtime_dependency(%q<commander>, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>, [">= 0"])
  s.add_runtime_dependency('octopi', [">= 0"])
  s.add_development_dependency(%q<minitest>, [">= 0"])
  s.add_development_dependency(%q<open4>, [">= 0"])
end

