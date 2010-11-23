module Shhh
  module Commands
    module Core
      module Files
        
        def symlink(path, destination)
          ln_s(path, destination)
          info "Symlinking %s -> %s", destination, path
        end

        def move(path, destination)
          mv(path, destination)
          info "Moving %s to %s", path, destination
        end

        def write_file(path, content, io_mode='w')
          File.open(path, io_mode) do |file|
            file.write(content)
          end
        end
        
        def home_path
          Shhh.home_path
        end

        def dotfiles_path
          Shhh.dotfiles_path
        end
      
        def secrets_path
          Shhh.secrets_path
        end

        def generate_dotfile_path(file_path)
          File.join(dotfiles_path, visible_name(file_path))
        end

        def dotfile_exists?(file_path)
          File.exist?(generate_dotfile_path(file_path))
        end

        def visible_name(file_path)
          File.basename(file_path).gsub(/^\./, '')
        end
        
      end
    end
  end    
end