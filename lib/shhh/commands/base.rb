require 'fileutils'
require File.expand_path('core/secrets', File.dirname(__FILE__))
require File.expand_path('core/files', File.dirname(__FILE__))
require File.expand_path('core/output', File.dirname(__FILE__))

module Shhh
  module Commands

    # Shhh::Commands::Base is the base class for all commands in the system.
    #
    # Most behavior is actually defined by Core modules.
    #
    # Actual commands, which are created by creating a subclass of Base, must
    # implement an instance method `execute`.
    #
    # Running a Commands::Base subclass is done by instantiating it with
    # arguments and options.
    class Base

      # The extension to append to files when redacting information
      DYNAMIC_EXTENSION = 'classified'

      include FileUtils
      include Core::Files
      include Core::Secrets
      include Core::Output

      def initialize(args, options)
        @args = args
        @options = options
        run
      end

      # Begin execution of this command. Subclasses should not override this
      # method, instead, they should define an `execute` method that performs
      # their actual work.
      def run
        begin
          execute
          say('')
          success "Done."
        rescue CommandAborted, UnrecoverableError => e
          error(e.message)
          exit(255)
        end
      end

      # Perform this command's work.
      #
      # This method should be overridden in subclasses.
      def execute
        raise "Not Implemented"
      end

      # Add a file to the .gitignore file inside the dotfiles_path
      #
      # filename - The String filename to be appended to the list of ignored paths
      #
      # Returns the Integer number of bytes written.
      def add_to_git_ignore(filename)
        File.open(File.join(dotfiles_path, '.gitignore'), "a+") do |file|
          contents = file.read
          unless contents =~ %r{^#{filename}$}
            info("Adding #{filename} to #{File.join(dotfiles_path, '.gitignore')}")
            file.write(filename + "\n")
          end
        end
      end

      # Check to see if the dotfiles directory exists. If it doesn't, present
      # the user with the option to create it. If the user accepts, the
      # directory is created.
      #
      # If the user declines creating the directory, a CommandAborted exception
      # is raised.
      def verify_dotfiles_directory_exists
        if !File.directory?(dotfiles_path)
          choice = choose("You don't appear to have a git repository at #{dotfiles_path}. Do you want to create one now?", 'create', 'abort') do |menu|
            menu.index = :letter
            menu.layout = :one_line
          end
          if choice == 'create'
            info "Creating a directory at #{dotfiles_path}"
            mkdir_p(dotfiles_path)
            info `git init #{dotfiles_path}`
          else
            raise CommandAborted.new('Can not continue without a dotfiles repository!')
          end
        end
      end

    end
  end
end
