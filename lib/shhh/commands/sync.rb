module Shhh
  module Commands

    # Sync scans the dotfiles directory for dotfiles, and creates any missing
    # symlinks in the user's home directory.
    #
    # A message is printed out for each file, indicating if a matching symlink
    # was found in the home directory or if one was created.
    #
    # If there is a symlink in the user's home directory with a dotfile's name
    # but it is pointing to the wrong location, it is removed and a new symlink
    # is created in its place.
    class Sync < Base

      # Scan the dotfiles directory for files, and process each one. Files
      # with names containing '.old' are ignored and a warning is show to alert
      # the user of their presence.
      def execute
        intro "Synchronizing dotfiles between #{dotfiles_path} and #{home_path}"

        Dir.glob(File.join(dotfiles_path, '*')) do |path|
          basename = File.basename(path)
          next if %w{. ..}.include?(basename)
          next if basename =~ /.#{REDACTED_EXTENSION}$/

          if basename.include?('.old')
            warn "Skipping %s, you may want to remove it.", path
          else
            create_or_verify_symlink(basename)
          end
        end
      end

      private

      # Verifies if a symlink following shhh's conventions exists for the
      # supplied filename. Creates a symlink if it doesn't exist, or if there
      # is a corectly named symlink with the wrong target.
      #
      # basename - The String filename to use when building paths
      def create_or_verify_symlink(basename)
        dotfile_name = ".#{basename}"
        symlink_path = File.join(home_path, dotfile_name)
        dotfile_path = generate_dotfile_path(basename)

        if File.exist?(symlink_path)
          if File.symlink?(symlink_path)
            if File.readlink(symlink_path) == dotfile_path
              info "Symlink verified: %s -> %s", symlink_path, dotfile_path
              return
            else
              info "Removing outdated symlink %s", symlink_path
              rm(symlink_path)
            end
          else
            info "Found normal file at %s, skipping...", symlink_path
            return
          end
        end

        symlink(dotfile_path, symlink_path)
      end

    end
  end
end
