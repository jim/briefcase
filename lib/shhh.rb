require File.expand_path('shhh/commands/base', File.dirname(__FILE__))
require File.expand_path('shhh/commands/import', File.dirname(__FILE__))
require File.expand_path('shhh/commands/sync', File.dirname(__FILE__))

module Shhh
  
  DEFAULT_DOTFILES_DIR = ENV['SHHH_DOTFILES_DIR'] || '~/.dotfiles'
  DEFAULT_HOME_DIR = ENV['SHHH_HOME_DIR'] || '~'
  
  class << self
    attr_accessor :dotfiles_path
    attr_accessor :home_path
    
    def dotfiles_path
      @dotfiles_path ||= File.expand_path(DEFAULT_DOTFILES_DIR)
    end
    
    def home_path
      @home_path ||= File.expand_path(DEFAULT_HOME_DIR)
    end
  end
  
  class UnrecoverableError < StandardError; end
  class CommandAborted < StandardError; end

end