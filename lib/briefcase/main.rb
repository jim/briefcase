require 'highline/import'
require File.expand_path('../briefcase', File.dirname(__FILE__))

# In the case of the git passthrough command, we want to pass the complete command
# off to git so the options aren't mangled by Commander.
#
# Initializing a Briefcase::Commands::Git object will eventually call out to
# git using exec, so this script will be aborted.
if ARGV[0] == 'git'
  Briefcase::Commands::Git.new(ARGV[1..-1], {})
end

require 'commander/import'

program :name, 'Briefcase'
program :version, Briefcase::VERSION
program :description, 'Makes it easier to keep dotfiles in git'

command :import do |c|
  c.syntax = 'briefcase import PATH'
  c.description = 'Move PATH to the version controlled directory and symlink its previous location to its new one.'
  c.when_called Briefcase::Commands::Import
end

command :redact do |c|
  c.syntax = 'briefcase redact PATH'
  c.description = 'Edit PATH to remove sensitive information, save the edited version to the version controlled directory, and symlink its previous location to its new one, and add to .gitignore.'
  c.when_called Briefcase::Commands::Redact
end

command :sync do |c|
  c.syntax = 'briefcase sync'
  c.description = 'Updates all symlinks for files included in ~/.dotfiles'
  c.when_called Briefcase::Commands::Sync
end

command :generate do |c|
  c.syntax = 'briefcase generate'
  c.description = 'Generates static versions of all redacted dotfiles in ~/.dotfiles'
  c.when_called Briefcase::Commands::Generate
end

# This is a placeholder so that this command appears in the documentation. Any git
# passthrough commands are caught earlier in this file.
command :git do |c|
  c.syntax = 'briefcase git [options]'
  c.description = 'Run a git command in the dotfiles directory'
end

default_command :help

# command :suggest do |c|
#   c.syntax = 'briefcase suggest'
#   c.description 'List dotfiles that are in your home directory and not in ~/.dotfiles'
#   c.when_called Briefcase::Commands::Suggest
# end
