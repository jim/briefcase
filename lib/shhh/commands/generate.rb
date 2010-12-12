module Shhh
  module Commands
    class Generate < Base
      
      def execute
        intro "Generating classified dotfiles in #{dotfiles_path}"
        
        Dir.glob(File.join(dotfiles_path, "*.#{DYNAMIC_EXTENSION}")) do |path|
          generate_file_for_path(path)
        end
        
        write_secrets
      end
   
      private
      
      def generate_file_for_path(path)
        static_path = path.gsub(/.#{DYNAMIC_EXTENSION}$/, '')
        basename = File.basename(static_path)
        dotfile_path = generate_dotfile_path(basename)
        
        if !File.exist?(dotfile_path) || overwrite_file?(dotfile_path)
          info "Generating %s", dotfile_path
          content = File.read(path)
          edited_content = content.gsub(COMMENT_REPLACEMENT_REGEX) do |match|
            key = $2.to_sym
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