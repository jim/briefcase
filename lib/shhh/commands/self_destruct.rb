module Shhh
  module Commands
    class SelfDestruct < Base
      
      def execute
        intro "Self-destructing..."
        
        # generate all classified files, and fail if a secret isn't found
        # for each unclassified file, remove it's symlink and copy the file back
        # delete .dotfiles directory
        # prompt to remove secrets file
        
      end
   
    end
  end
end