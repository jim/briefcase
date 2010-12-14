module Shhh
  module Commands
    class Redact < Import
      
      EDITING_HELP_TEXT = <<-TEXT
# Edit the file below, replacing and sensitive information to turn this:
#
#   password: superSecretPassword
#
# Into:
#
#   password: # shhh(:password)
#
########################################################################
TEXT
      
      private
      
      def import_file
        super
        create_dynamic_version
      end
      
      def create_dynamic_version
        destination = generate_dotfile_path(@path)
        dynamic_path = destination + ".#{DYNAMIC_EXTENSION}"
        info "Creating classified version at #{dynamic_path}"
        
        content_to_edit = original_content = File.read(destination)
        
        unless Shhh.testing?
          content_to_edit = EDITING_HELP_TEXT + content_to_edit
        end
        
        write_file(dynamic_path, content_to_edit)
        edited_content = edit_file_with_editor(dynamic_path).gsub!(EDITING_HELP_TEXT, '')
        write_file(dynamic_path, edited_content)

        edited_content.lines.each_with_index do |line, line_index|
          if line =~ COMMENT_REPLACEMENT_REGEX
            key = $2.to_sym
            mask = %r{^#{$1}(.*)$}
            value = original_content.lines.to_a[line_index].match(mask)[1]
            info "Storing secret value for key: #{key}"
            add_secret(destination, key, value)
          end
        end
        
        write_secrets
        add_to_git_ignore(visible_name(destination))
      end
      
      def edit_file_with_editor(path)
        editor_command = ENV['EDITOR'] || 'vim'
        system(editor_command, path)
        File.read(path)
      end
      
    end
  end
end