require 'commander/import'

program :name, 'Shhh'
program :version, '0.0.1'
program :description, 'Makes it easier to keep dotfiles in git'

command :import do |c|
  c.syntax = 'shhh import PATH'
  c.description = 'Move PATH to the version controlled directory and symlink from its current location'
  c.when_called Shhh::Commands::Import
end

command :link do |c|
  c.syntax = 'shhh link'
  c.description = 'Updates all symlinks for files included in ~/.dotfiles'
  c.when_called Shhh::Commands::Link
end

command :generate do |c|
  c.syntax = 'shhh generate'
  c.description = 'Generates static versions of all erb dotfiles in ~/.dotfiles'
  # c.when_called Shhh::Commands::Generate
end