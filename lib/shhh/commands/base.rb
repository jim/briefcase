require 'fileutils'
require File.expand_path('core/secrets', File.dirname(__FILE__))
require File.expand_path('core/files', File.dirname(__FILE__))
require File.expand_path('core/output', File.dirname(__FILE__))

module Shhh
  module Commands
    class Base

      include FileUtils
      include Core::Files
      include Core::Secrets
      include Core::Output
      
      def initialize(args, options)
        @args = args
        @options = options
        run
      end

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

      def add_to_git_ignore(filename)
        File.open(File.join(dotfiles_path, '.gitignore'), "a+") do |file|
          contents = file.read
          unless contents =~ %r{^#{filename}$}
            info("Adding #{filename} to #{File.join(dotfiles_path, '.gitignore')}")
            file.write(filename + "\n")
          end
        end
      end

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
