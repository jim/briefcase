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
    
      def success(*args); say $terminal.color(format(*args), :green); end
      def info(*args); say $terminal.color(format(*args), :yellow); end
      def error(*args); say $terminal.color(format(*args), :red); end
      def warn(*args); say $terminal.color(format(*args), :yellow); end
      
    end
  end
end