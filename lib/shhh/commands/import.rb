module Shhh
  module Commands
    class Import < Base
      
      def execute
        say @args.first
      end
      
    end
  end
end