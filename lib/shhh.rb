require 'yaml'

require 'active_support/core_ext/hash/deep_merge'

require File.expand_path('shhh/commands', File.dirname(__FILE__))
require File.expand_path('shhh/version', File.dirname(__FILE__))

module Shhh
  
  DEFAULT_HOME_PATH = '~'
  DEFAULT_DOTFILES_PATH = File.join(DEFAULT_HOME_PATH, '.dotfiles')
  DEFAULT_SECRETS_PATH = File.join(DEFAULT_HOME_PATH, '.shhh_secrets')
  
  class << self
    attr_accessor :dotfiles_path, :home_path, :secrets_path, :testing
    
    def dotfiles_path
      @dotfiles_path ||= File.expand_path(ENV['SHHH_DOTFILES_PATH'] || DEFAULT_DOTFILES_PATH)
    end
    
    def home_path
      @home_path ||= File.expand_path(ENV['SHHH_HOME_PATH'] || DEFAULT_HOME_PATH)
    end
    
    def secrets_path
      @secrets_path ||= File.expand_path(ENV['SHHH_SECRETS_PATH'] || DEFAULT_SECRETS_PATH)
    end
    
    def testing?
      @testing ||= ENV['SHHH_TESTING'] == 'true'
    end
  end
  
  class UnrecoverableError < StandardError; end
  class CommandAborted < StandardError; end

end