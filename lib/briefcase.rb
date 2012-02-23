require 'yaml'

require File.expand_path('briefcase/commands', File.dirname(__FILE__))
require File.expand_path('briefcase/version', File.dirname(__FILE__))

module Briefcase

  class << self
    attr_accessor :dotfiles_path, :home_path, :secrets_path, :testing

    # The user's home path
    def default_home_path
      '~'
    end

    # The default path where dotfiles are stored
    def default_dotfiles_path
      File.join(home_path, '.dotfiles')
    end

    # The default path to where secret information is stored
    def default_secrets_path
      File.join(home_path, '.briefcase_secrets')
    end

    def dotfiles_path
      @dotfiles_path ||= File.expand_path(ENV['BRIEFCASE_DOTFILES_PATH'] || default_dotfiles_path)
    end

    def home_path
      @home_path ||= File.expand_path(ENV['BRIEFCASE_HOME_PATH'] || default_home_path)
    end

    def secrets_path
      @secrets_path ||= File.expand_path(ENV['BRIEFCASE_SECRETS_PATH'] || default_secrets_path)
    end

    def testing?
      @testing ||= ENV['BRIEFCASE_TESTING'] == 'true'
    end
  end

  class UnrecoverableError < StandardError; end
  class CommandAborted < StandardError; end

end
