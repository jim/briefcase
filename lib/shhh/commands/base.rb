require 'fileutils'

module Shhh
  module Commands
    class Base

      include FileUtils

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
        rescue CommandAborted => e
          fail(e.message)
          exit(-1)
        end
      end

      def symlink(path, destination)
        ln_s(path, destination)
        info "Symlinking %s -> %s", destination, path
      end

      def move(path, destination)
        mv(path, destination)
        info "Moving %s to %s", path, destination
      end

      def add_to_git_ignore(filename)
        File.open(File.join(dotfiles_path, '.gitignore'), "r+") do |file|
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
            info "Initializing git repository at #{dotfiles_path}"
            `git init #{dotfiles_path}`
          else
            raise CommandAborted.new('Can not continue without a dotfiles repository!')
          end
        end
      end

      def home_path
        Shhh.home_path
      end

      def dotfiles_path
        Shhh.dotfiles_path
      end
      
      def secrets_path
        Shhh.secrets_path
      end

      def generate_dotfile_path(file_path)
        File.join(dotfiles_path, visible_name(file_path))
      end

      def dotfile_exists?(file_path)
        File.exist?(generate_dotfile_path(file_path))
      end

      def visible_name(file_path)
        File.basename(file_path).gsub(/^\./, '')
      end

      def success(*args); say $terminal.color(format(*args), :green, :bold); end
      def info(*args); say $terminal.color(format(*args), :yellow); end
      def error(*args); say $terminal.color(format(*args), :red); end
      def warn(*args); say $terminal.color(format(*args), :magenta); end

      def fail(*args); say $terminal.color(format(*args), :red); end
      def intro(*args); say $terminal.color(format(*args), :bold); say(''); end

    end
  end
end
