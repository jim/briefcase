require File.expand_path('lib/shhh/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{shhh}
  s.version = Shhh::VERSION
  s.authors = ["Jim Benton"]
  s.date = %q{2010-12-6}
  s.default_executable = %q{shhh}
  s.description = %q{Command line program to migrate dotfiles to a git repo at ~/.dotfiles and generate static dotfiles with secret values.}
  s.email = %q{jim@autonomousmachine.com}
  s.executables = ["shhh"]
  s.extra_rdoc_files = %w{README.rdoc LICENSE}
  s.files = Dir['lib/**/*.rb'] +                      # library
            Dir['bin/*'] +                            # executable
            Dir['spec/**/*.rb'] +                     # spec files
            Dir['spec/bin/editor'] +                  # spec editor
            %w{README.rdoc LICENSE shhh.gemspec Rakefile}  # misc
  
  s.homepage = %q{http://github.com/jim/shhh}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Shhh manages dotfiles and handles keeping their secrets safe}
  s.test_files = Dir['spec/*.rb']

  s.add_runtime_dependency(%q<commander>, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>, [">= 0"])
  s.add_development_dependency(%q<minitest>, [">= 0"])
end

