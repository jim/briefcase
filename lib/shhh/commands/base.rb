module Shhh
  module Commands
    class Base
      
      def initialize(args, options)
        @args = args
        @options = options
        execute
      end
      
      def execute
      end
      
    end
  end
end