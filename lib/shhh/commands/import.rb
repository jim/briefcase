require 'tempfile'

module Shhh
  module Commands

    # Import copies a dotfile into the dotfiles directory and created a
    # symlink in the file's previous location, pointing to its new location.
    #
    # The file's name in the repository will be the dotfile's name with the
    # leading period removed. So, importing '~/.bashrc' will move that file to
    # ~/.dotfiles/bashrc and then create a symlink at ~/.bashrc pointing to
    # ~/.dotfiles/bashrc.
    #
    # If there was already a file located at ~/.dotfiles/bashrc, the user will
    # be asked if it is OK to mvoe the existing file aside. If the user accepts
    # the move, the existing file is renamed to bashrc.old.1 before the new
    # file is imported, and a message would be shown indicating this has
    # occurred.
    class Import < Base

      # Execute verifies that the dotfiles directory exists before attempting
      # the import.
      #
      # Raises an error if the specified path does not exist.
      def execute
        verify_dotfiles_directory_exists

        @path = File.expand_path(@args.first)
        raise UnrecoverableError.new("#{@path} does not exist") unless File.exist?(@path)

        intro("Importing %s into %s", @path, dotfiles_path)
        import_file
      end

      private

      # Import a file. Creates the dotfiles directory if it doesn't exist
      # before attempting the import. Prompts the user when there is a naming
      # collision between an existing dotfile and the file to be imported.
      #
      # Raises CommandAborted if there is a colision and the user declines to
      # move the existing file.
      def import_file
        collision = dotfile_exists?(@path)
        if !collision || overwrite_file?

          mkdir_p(dotfiles_path)
          destination = generate_dotfile_path(@path)

          if collision
            existing = Dir.glob("#{destination}.old.*").size
            sideline = "#{destination}.old.#{existing+1}"
            info "Moving %s to %s", destination, sideline
            mv(destination, sideline)
          end

          move(@path, destination)
          symlink(destination, @path)
        else
          raise CommandAborted.new('Cancelled.')
        end
      end

      # Ask the user if it is OK to move an existing file so a new file can be
      # imported.
      #
      # Returns whether the user accepts the move or not as a Boolean.
      #
      # TODO: Rename this method as it doesn't overwrite anything.
      def overwrite_file?
        decision = choose("#{@path} already exists as a dotfile. Do you want to replace it? Your original file will be renamed.", 'replace', 'abort') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end

        decision == 'replace'
      end

    end
  end
end
