module Shhh
  module Commands
    class SelfDestruct < Base
      
      def execute
        intro "Self-destructing..."
        
        # if confirm_destruction? 
          generate_classified_files
          restore_dotfiles_for_symlinks
          delete_dotfiles_directory
          remove_dotfiles_directory
        # end
      end
   
      private
      
      def generate_classified_files
        Generate.new({}, {:chained => true})
      end
      
      def restore_dotfiles_for_symlinks
        
      end
      
      def delete_dotfiles_directory
        
      end
      
      def remove_dotfiles_directory
        
      end
      
      def confirm_destruction?
        decision = choose("Are you sure you want remove #{dotfiles_path} PERMANENTLY?", 'remove', 'abort') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end
        decision == 'remove'
      end
   
    end
  end
end