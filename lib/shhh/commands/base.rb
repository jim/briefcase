require 'fileutils'

module Shhh
  module Commands
    class Base
      
      include FileUtils
      
      def initialize(args, options)
        @args = args
        @options = options
        execute
        
        puts
        success "Done."
      end
      
      def execute
      end
    
      def symlink(path, destination)        
        ln_s(path, destination)
        info "Symlinking %s -> %s", destination, path
      end
    
      def move(path, destination) 
        mv(path, destination)
        info "Moving %s to %s", path, destination  
      end
      
      def home_path
        Shhh.home_path
      end
      
      def dotfiles_path
        Shhh.dotfiles_path
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
    
      def success(*args); say $terminal.color(format(*args), :green, :bold); end
      def info(*args); say $terminal.color(format(*args), :yellow); end
      def error(*args); say $terminal.color(format(*args), :red); end
      def warn(*args); say $terminal.color(format(*args), :magenta); end
      
      def fail(*args); say $terminal.color(format(*args), :red); exit; end
      def intro(*args); say $terminal.color(format(*args), :bold); puts; end
      
    end
  end
end