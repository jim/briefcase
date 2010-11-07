require 'yaml'

require 'active_support/core_ext/hash/deep_merge'

require File.expand_path('shhh/commands/base', File.dirname(__FILE__))
require File.expand_path('shhh/commands/import', File.dirname(__FILE__))
require File.expand_path('shhh/commands/sync', File.dirname(__FILE__))

module Shhh
  
  DEFAULT_DOTFILES_DIR = '~/.dotfiles'
  DEFAULT_HOME_DIR = '~'
  DEFAULT_SECRETS_PATH = '~/.shhh_secrets'
  
  class << self
    attr_accessor :dotfiles_path, :home_path, :secrets_path
    
    def dotfiles_path
      @dotfiles_path ||= File.expand_path(ENV['SHHH_DOTFILES_DIR'] || DEFAULT_DOTFILES_DIR)
    end
    
    def home_path
      @home_path ||= File.expand_path(ENV['SHHH_HOME_DIR'] || DEFAULT_HOME_DIR)
    end
    
    def secrets_path
      @secrets_path ||= File.expand_path(ENV['SHHH_SECRETS_PATH'] || DEFAULT_SECRETS_PATH)
    end
  end
  
  class UnrecoverableError < StandardError; end
  class CommandAborted < StandardError; end

end