require 'commander'

require File.expand_path('shhh/commands/base', File.dirname(__FILE__))
require File.expand_path('shhh/commands/import', File.dirname(__FILE__))
require File.expand_path('shhh/commands/sync', File.dirname(__FILE__))
require File.expand_path('shhh/main', File.dirname(__FILE__))

module Shhh
  
  DEFAULT_DOTFILES_DIR = '.dotfiles' || ENV['SHHH_DOTFILES_DIR']
  DEFAULT_HOME_DIR = '~' || ENV['SHHH_HOME_DIR']
  
  class << self
    attr_reader :dotfiles_path
    attr_reader :home_path
    
    def dotfiles_path
      @dotfiles_path ||= File.join(home_path, DEFAULT_DOTFILES_DIR)
    end
    
    def home_path
      @home_path ||= `echo #{DEFAULT_HOME_DIR}`.strip!
    end
  end
  
end