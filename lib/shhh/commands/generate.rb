module Shhh
  module Commands
    class Generate < Base
      
      def execute
        
        intro "Generating dynamic dotfiles in #{dotfiles_path}"
        
        secrets = read_secrets
        
        Dir.glob(File.join(dotfiles_path, '*.erb')) do |path|
          basename = File.basename(path.gsub(/.erb$/, ''))
          dotfile_path = generate_dotfile_path(basename)
          
          if !File.exist?(dotfile_path) || overwrite_file?(dotfile_path)
            
            # generate statis file from erb
            
          else
            
            # skip it!
            
          end
          
          
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