module Shhh
  module Commands
    class Sync < Base
      
      def execute
        
        intro "Synchronizing dotfiles between #{dotfiles_path} and #{home_path}"
        
        Dir.glob(File.join(dotfiles_path, '*')) do |path|
          basename = File.basename(path)
          next if %w{. ..}.include?(basename)
          
          if basename.include?('.old')
            warn "Skipping %s, you may want to remove it.", path
          else
            dotfile_name = ".#{basename}"
            symlink_path = File.join(home_path, dotfile_name)
            dotfile_path = generate_dotfile_path(basename)

            if File.exist?(symlink_path)
              if File.readlink(symlink_path) != dotfile_path
                info "Removing outdated symlink %s", symlink_path
                rm(symlink_path)
                symlink(dotfile_path, symlink_path)
              else
                info "Symlink verified: %s -> %s", symlink_path, dotfile_path
              end
            else
              symlink(dotfile_path, symlink_path)
            end
          end
        end
        
      end
   
    end
  end
end