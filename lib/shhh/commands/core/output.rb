module Shhh
  module Commands
    module Core
      module Output

        # Print some bold green text to the console.
        def success(*args); say $terminal.color(format(*args), :green, :bold); end

        # Print some yellow text to the console.
        def info(*args); say $terminal.color(format(*args), :yellow); end

        # Print some red text to the console.
        def error(*args); say $terminal.color(format(*args), :red); end

        # Print some magenta text to the console.
        def warn(*args); say $terminal.color(format(*args), :magenta); end

        # Print some bold text to the console.
        def intro(*args); say $terminal.color(format(*args), :bold); say(''); end

      end
    end
  end
end
