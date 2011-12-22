module Briefcase
  module Commands
    module Core
      module Files

        # Create a symlink at a path with a given target.
        #
        # target - the String target for the symlink
        # destination - The String location for the symlink
        def symlink(target, destination)
          ln_s(target, destination)
          info "Symlinking %s -> %s", destination, target
        end

        # Move a file from one location to another
        #
        # path - The String path to be moved
        # destination - The String path to move the file to
        def move(path, destination)
          mv(path, destination)
          info "Moving %s to %s", path, destination
        end

        # Write some content to a file path.
        #
        # path - The String path to the file that should be written to
        # content - The String content to write to the file
        # io_mode - The String IO mode to use when writing the file
        def write_file(path, content, io_mode='w')
          File.open(path, io_mode) do |file|
            file.write(content)
          end
        end

        # Returns the globally configured home path for the user.
        def home_path
          Briefcase.home_path
        end

        # Returns the globally configured dotfiles path.
        def dotfiles_path
          Briefcase.dotfiles_path
        end

        # Returns the globally configured secrets path.
        def secrets_path
          Briefcase.secrets_path
        end

        # Build a full dotfile path from a given file path, using the gobal
        # dotfiles path setting.
        #
        # file_path - The String path to build a dotfile path from
        def generate_dotfile_path(file_path)
          File.join(dotfiles_path, visible_name(file_path))
        end

        # Check to see if there is a stored dotfile in the dotfiles directory
        # that corresponds to the specified file.
        #
        # file_path - The String file name to check
        #
        # Returns whether the file exists or not as a Boolean
        def dotfile_exists?(file_path)
          File.exist?(generate_dotfile_path(file_path))
        end

        # Convert a file path into a file name and remove a leading period if
        # it exists.
        #
        # file_path - The String file path to create a visible name for
        #
        # Returns the manipulated file name
        def visible_name(file_path)
          File.basename(file_path).gsub(/^\./, '')
        end

      end
    end
  end
end
