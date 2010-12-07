require 'tempfile'

module Shhh
  module Commands
    class Import < Base
      
      EDITING_HELP_TEXT = <<-TEXT
# Edit the file below, replacing and sensitive information to turn this:
#
#   password: superSecretPassword
#
# Into:
#
#   password: # shhh(:password)
#

TEXT
      
      def execute
        verify_dotfiles_directory_exists
        
        @path = File.expand_path(@args.first)
        raise UnrecoverableError.new("#{@path} does not exist") unless File.exist?(@path)

        intro("Importing %s into %s", @path, dotfiles_path)
        import_file
      end
      
      private
      
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
          
          if @options.dynamic
            create_dynamic_version
          end
        else
          raise CommandAborted.new('Cancelled.')
        end
      end
      
      
      def overwrite_file?
        decision = choose("#{@path} already exists as a dotfile. Do you want to replace it? Your original file will be renamed.", 'replace', 'abort') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end
        
        decision == 'replace'
      end
      
      def create_dynamic_version
        destination = generate_dotfile_path(@path)
        dynamic_path = destination + ".#{DYNAMIC_EXTENSION}"
        info "Creating dynamic version at #{dynamic_path}"
        
        original_content = File.read(destination)
        unless Shhh.testing?
          original_content.insert 0, EDITING_HELP_TEXT
        end
        
        write_file(dynamic_path, original_content)
        edited_content = edit_file_with_editor(dynamic_path)

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