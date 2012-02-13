module Briefcase
  module Commands

    # Redact is similar to Import, but it will also prompt the user to replace
    # any secure information in the file with a special replacement syntax. Any
    # values replaces in this way will be stored in the secrets file, and the
    # dotfile will be imported sans secrets.
    class Redact < Import

      EDITING_HELP_TEXT = <<-TEXT
# Edit the file below, replacing and sensitive information to turn this:
#
#   password: superSecretPassword
#
# Into:
#
#   password: # briefcase(password)
#
########################################################################
TEXT

      private

      def import_file
        super
        create_redacted_version
      end

      # Copy the file to be imported into the dotfiles directory and append the
      # redacted extension to its name. This file is then opened in an
      # editor, where the user has a chance to replace sensitive information.
      # After saving and closing the file, the differences are examined and the
      # replaces values are detected. These values and their replacement keys
      # are stored in the secrets file.
      def create_redacted_version
        destination = generate_dotfile_path(@path)
        redacted_path = destination + ".#{REDACTED_EXTENSION}"
        info "Creating redacted version at #{redacted_path}"

        content_to_edit = original_content = File.read(destination)

        unless Briefcase.testing?
          content_to_edit = EDITING_HELP_TEXT + content_to_edit
        end

        write_file(redacted_path, content_to_edit)
        edited_content = edit_file_with_editor(redacted_path).gsub!(EDITING_HELP_TEXT, '')
        write_file(redacted_path, edited_content)

        edited_content.lines.each_with_index do |line, line_index|
          if line =~ COMMENT_REPLACEMENT_REGEX
            key = $2
            mask = %r{^#{$1}(.*)$}
            value = original_content.lines.to_a[line_index].match(mask)[1]
            info "Storing secret value for key: #{key}"
            add_secret(destination, key, value)
          end
        end

        write_secrets
        add_to_git_ignore(visible_name(destination))
      end

      # Open a file with an editor. The editor can be specified using the
      # EDITOR environment variable, with vim being the current default.
      #
      # Returns the content of the file after the editor is closed.
      def edit_file_with_editor(path)
        editor_command = ENV['BRIEFCASE_EDITOR'] || 'vim'
        system(editor_command, path)
        File.read(path)
      end

    end
  end
end
