module Shhh
  module Commands
    class Pull < Base
      def execute
        intro "Running `git pull` in #{dotfiles_path}"
        puts `cd #{dotfiles_path} && git pull`
      end
    end
  end
end
