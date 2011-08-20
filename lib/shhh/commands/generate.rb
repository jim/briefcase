module Shhh
  module Commands

    # Generate looks through through the dotfiles directory for any redacted
    # dotfiles. It attempts to generate a normal version of each file it finds,
    # using the values stored in the .shhh_secrets file.
    class Generate < Base

      def execute
        intro "Generating redacted dotfiles in #{dotfiles_path}"

        Dir.glob(File.join(dotfiles_path, "*.#{REDACTED_EXTENSION}")) do |path|
          generate_file_for_path(path)
        end

        write_secrets
      end

      private

      # Generates a standard dotfile from a redacted dotfile
      #
      # This method will attempt to find secret values in the secrets file. If
      # any aren't found, it will print a message about the offending key and
      # add that key to the secrets file without a value (to make it easier for
      # users to fill in the missing value).
      #
      # path - the path to the redacted dotfile
      def generate_file_for_path(path)
        static_path = path.gsub(/.#{REDACTED_EXTENSION}$/, '')
        basename = File.basename(static_path)
        dotfile_path = generate_dotfile_path(basename)

        if !File.exist?(dotfile_path) || overwrite_file?(dotfile_path)
          info "Generating %s", dotfile_path
          content = File.read(path)
          edited_content = content.gsub(COMMENT_REPLACEMENT_REGEX) do |match|
            key = $2
            if (replacement = get_secret(static_path, key))
              info "Restoring secret value for key: #{key}"
              $1 + replacement
            else
              info "Secret missing for key: #{key}"
              add_secret(static_path, key, '')
              match
            end
          end
          write_file(dotfile_path, edited_content)
        else
          info "Skipping %s as there is already a file at %s", path, dotfile_path
        end
      end

      # TODO consolidate this method and Import#overwrite_file?
      def overwrite_file?(path)
        decision = choose("#{path} already exists as a dotfile. Do you want to replace it?", 'replace', 'skip') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end
        decision == 'replace'
      end

    end
  end
end
