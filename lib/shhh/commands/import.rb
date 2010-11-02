module Shhh
  module Commands
    class Import < Base
      
      def execute
        success("Importing %s", @args.first)
      end
      
    end
  end
end