require 'tempfile'

module Shhh
  module Commands
    class Import < Base
      
      def execute
        
        verify_dotfiles_directory_exists
        
        @path = File.expand_path(@args.first)
        intro("Importing %s into %s", @path, dotfiles_path)

        fail("%s does not exist", @path) unless File.exist?(@path)

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
          
          if @options.erb
            erb_path = generate_dotfile_path(@path + '.erb')
            
            original_content = File.read(destination)
            original_content.insert(0, "# Edit the file below, replacing and sensitive information with shhh(:token).\n# For example:\n#\n# password: shhh(:password)")
            
            edited_content = ''
            
            Tempfile.open(Time.new.to_i.to_s + '.tmp') do |tempfile|
              File.open(tempfile.path, 'r+') { |f| f.write(original_content) }
              editor_command = ENV['EDITOR'] || 'vim'
              system(editor_command, tempfile.path)
              edited_content = File.open(tempfile.path, 'r') { |f| f.read }
            end

            replacement_regex = /^(.*)#\s*shhh\(:([a-zA-Z_]+)\)\s*$/
            edited_content.lines.each_with_index do |line, line_index|
              if line =~ replacement_regex
                key = $2
                mask = %r{^#{$1}(.*)$}
                value = original_content.lines.to_a[line_index].match(mask)[1]
                add_secret(destination, key, value)
              end
            end
            
            write_secrets
            
            info "Creating ERB version at #{erb_path}"
            # cp(destination, erb_path)
            # add_to_git_ignore(visible_name(@path))
          end
          
        else
          raise CommandAborted.new('Cancelled.')
        end
        
      end
      
      def add_secret(path, key, value)
        @new_secrets ||= {}
        @new_secrets[path] ||= {}
        @new_secrets[path][key] = value;
      end
      
      def write_secrets  
        current_secrets = if File.exist?(secrets_path)
          info "Loading existing secrets from #{secrets_path}"
          YAML.load_file(secrets_path)
        else
          {}
        end
        
        current_secrets.deep_merge!(@new_secrets || {})
        
        File.open(secrets_path, 'w') do |file|
          file.write(current_secrets.to_yaml)
        end
      end
      
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