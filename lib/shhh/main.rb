require 'commander/import'
require File.expand_path('../shhh', File.dirname(__FILE__))

program :name, 'Shhh'
program :version, Shhh::VERSION
program :description, 'Makes it easier to keep dotfiles in git'

command :import do |c|
  c.syntax = 'shhh import PATH'
  c.description = 'Move PATH to the version controlled directory and symlink its previous location to its new one.'
  c.when_called Shhh::Commands::Import
end

command :redact do |c|
  c.syntax = 'shhh redact PATH'
  c.description = 'Remove sensitive information, add redacted version to git, symlink, and add original to .gitignore.'
  c.when_called Shhh::Commands::Redact
end

command :sync do |c|
  c.syntax = 'shhh sync'
  c.description = 'Updates all symlinks for all dotfiles'
  c.when_called Shhh::Commands::Sync
end

command :generate do |c|
  c.syntax = 'shhh generate'
  c.description = 'Generates static versions of all dynamic dotfiles'
  c.when_called Shhh::Commands::Generate
end

command :pull do |c|
  c.syntax = 'shhh pull'
  c.description = 'Run `git pull` inside the dotfiles directory'
  c.when_called Shhh::Commands::Pull
end

default_command :help

# command :suggest do |c|
#   c.syntax = 'shhh suggest'
#   c.description 'List dotfiles that are in your home directory and not in ~/.dotfiles'
#   c.when_called Shhh::Commands::Suggest
# end
