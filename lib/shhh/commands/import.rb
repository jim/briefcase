module Shhh
  module Commands
    class Import < Base
      
      def execute
        
        @path = File.expand_path(@args.first)
        intro("Importing %s into %s", @path, dotfiles_path)

        fail("%s does not exist", @path) unless File.exist?(@path)

        collision = dotfile_exists?(@path)

        if !collision || overwrite_file?
          mkdir_p(dotfiles_path)
          destination = generate_dotfile_path(@path)
          
          if collision
            sideline = "#{destination}.old.#{generate_timestamp}"
            info "Renaming %s to %s", destination, sideline
            mv(destination, sideline)
          end
                    
          move(@path, destination)
          symlink(destination, @path)
          
          if @options.erb
            erb_path = generate_dotfile_path(@path + '.erb')
            info "Creating ERB version at #{erb_path}"
            cp(destination, erb_path)
          end
          
        else
          info "Cancelled"
        end
        
      end
      
      def overwrite_file?
        decision = choose("#{@path} already exists as a dotfile. Do you want to replace it? Your original file will be renamed.", 'replace', 'skip') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end
        
        decision == 'replace'
      end
      
    end
  end
end