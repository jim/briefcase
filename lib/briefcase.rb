require 'yaml'

require 'active_support/core_ext/hash/deep_merge'

require File.expand_path('briefcase/commands', File.dirname(__FILE__))
require File.expand_path('briefcase/version', File.dirname(__FILE__))

module Briefcase

  # The user's home path
  DEFAULT_HOME_PATH = '~'

  # The default path wher dotfiles are stored
  DEFAULT_DOTFILES_PATH = File.join(DEFAULT_HOME_PATH, '.dotfiles')

  # The default path to where secret information is stored
  DEFAULT_SECRETS_PATH = File.join(DEFAULT_HOME_PATH, '.briefcase_secrets')

  class << self
    attr_accessor :dotfiles_path, :home_path, :secrets_path, :testing

    def dotfiles_path
      @dotfiles_path ||= File.expand_path(ENV['BRIEFCASE_DOTFILES_PATH'] || DEFAULT_DOTFILES_PATH)
    end

    def home_path
      @home_path ||= File.expand_path(ENV['BRIEFCASE_HOME_PATH'] || DEFAULT_HOME_PATH)
    end

    def secrets_path
      @secrets_path ||= File.expand_path(ENV['BRIEFCASE_SECRETS_PATH'] || DEFAULT_SECRETS_PATH)
    end

    def testing?
      @testing ||= ENV['BRIEFCASE_TESTING'] == 'true'
    end
  end

  class UnrecoverableError < StandardError; end
  class CommandAborted < StandardError; end

end
