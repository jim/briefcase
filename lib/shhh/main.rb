require 'commander/import'

program :name, 'Shhh'
program :version, File.read(File.expand_path('../../VERSION', File.dirname(__FILE__)))
program :description, 'Makes it easier to keep dotfiles in git'

command :import do |c|
  c.syntax = 'shhh import PATH'
  c.description = 'Move PATH to the version controlled directory and symlink from its current location'
  c.when_called Shhh::Commands::Import
end

command :sync do |c|
  c.syntax = 'shhh sync'
  c.description = 'Updates all symlinks for files included in ~/.dotfiles'
  c.when_called Shhh::Commands::Sync
end

# command :generate do |c|
#   c.syntax = 'shhh generate'
#   c.description = 'Generates static versions of all erb dotfiles in ~/.dotfiles'
#   c.when_called Shhh::Commands::Generate
# end

# command :suggest do |c|
#   c.syntax = 'shhh suggest'
#   c.description 'List dotfiles that are in your home directory and not in ~/.dotfiles'
#   c.when_called Shhh::Commands::Suggest
# end