module Shhh
  module Commands
    module Core
      module Output

        def success(*args); say $terminal.color(format(*args), :green, :bold); end
        def info(*args); say $terminal.color(format(*args), :yellow); end
        def error(*args); say $terminal.color(format(*args), :red); end
        def warn(*args); say $terminal.color(format(*args), :magenta); end
        def intro(*args); say $terminal.color(format(*args), :bold); say(''); end

      end
    end
  end
end
