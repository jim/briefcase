module Shhh
  module Commands
    class Base
      def initialize(args, options)
        say "#{args.join(' ').to_s}"
      end
    end
  end
end