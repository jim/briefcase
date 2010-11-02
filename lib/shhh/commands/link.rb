module Shhh
  module Commands
    class Link < Base
      
      def execute
        Dir.glob(File.join(dotfiles_path, '*')) do |path|
          basename = File.basename(path)
          next if %w{. ..}.include?(basename)
          
          if basename.include?('.old')
            info "Skipping %s, you may want to remove it.", basename
          else
            dotfile_name = ".#{basename}"
            symlink(dotfile_path(basename), File.join(home_path, dotfile_name))
          end

        end
      end
   
    end
  end
end