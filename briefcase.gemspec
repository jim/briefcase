require File.expand_path('lib/briefcase/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{briefcase}
  s.version = Briefcase::VERSION
  s.summary = %q{Briefcase manages dotfiles and handles keeping their secrets safe}
  s.description = %q{Command line program to migrate dotfiles to a git repo at ~/.dotfiles and generate static dotfiles with secret values.}
  s.authors = ["Jim Benton"]
  s.date = %q{2011-12-22}
  s.default_executable = %q{briefcase}
  s.email = %q{jim@autonomousmachine.com}
  s.executables = ["briefcase"]
  s.files = Dir['lib/**/*.rb'] +                                # library
            Dir['bin/*'] +                                      # executable
            Dir['spec/**/*.rb'] +                               # spec files
            Dir['spec/bin/editor'] +                            # spec editor
            %w{README.md LICENSE briefcase.gemspec Rakefile}    # misc

  s.homepage = %q{http://github.com/jim/briefcase}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.test_files = Dir['spec/*.rb']

  s.add_runtime_dependency('commander')
  s.add_development_dependency('minitest')
  s.add_development_dependency('open4')
  s.add_development_dependency('rake', '0.9.2.2')
  s.add_development_dependency('turn')
end

