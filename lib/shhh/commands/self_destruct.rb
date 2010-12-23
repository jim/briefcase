module Shhh
  module Commands
    class SelfDestruct < Base
      
      def execute
        intro "Self-destructing..."

        if user_is_aware_of_the_consequences?
          generate_classified_files
          restore_all_dotfiles
          delete_dotfiles_directory
          conditionally_remove_secrets_file
        
          intro "All done. Thanks for trying out Shhh!"
        else
          info "Glad I checked. No files have been modified."
        end
      end
      
      private
      
      def user_is_aware_of_the_consequences?
        decision = choose("Are you sure you want to completely remove your dotfiles directory? This can not be undone.", 'remove', 'abort') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end
        
        decision == 'remove'
      end
      
      def generate_classified_files
        Shhh::Commands::Generate.new({}, {})
      end
      
      def restore_all_dotfiles
        Dir[dotfiles_path + '*'].each do |path|
          next if ['.', '..'].include?(File.basename(path))
          
          # if symlinked file exists, delete it
          # move file back to home directory
          
        end
      end
      
      def delete_dotfiles_directory
        rm_rf(dotfiles_path)
      end
   
      def conditionally_remove_secrets_file
        
      end
   
    end
  end
end