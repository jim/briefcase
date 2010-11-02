require 'fileutils'

module Shhh
  module Commands
    class Base
      
      include FileUtils
      
      DOTFILES_DIR = '.testfiles'
      
      def initialize(args, options)
        @args = args
        @options = options
        execute
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
        @home_path ||= `echo ~`.strip!
      end
      
      def dotfiles_path
        File.join(home_path, DOTFILES_DIR)
      end
      
      def dotfile_path(file_path)
        File.join(dotfiles_path, visible_name(file_path))
      end
      
      def dotfile_exists?(file_path)
        File.exist?(dotfile_path(file_path))
      end
    
      def visible_name(file_path)
        File.basename(file_path).gsub(/^\./, '')
      end
    
      def success(*args); say $terminal.color(format(*args), :green); end
      def info(*args); say $terminal.color(format(*args), :yellow); end
      def error(*args); say $terminal.color(format(*args), :red); end
      def warn(*args); say $terminal.color(format(*args), :yellow); end
      
      def fail(*args); say $terminal.color(format(*args), :red); exit; end
      
    end
  end
end