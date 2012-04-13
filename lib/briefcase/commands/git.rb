require 'escape'

module Briefcase
  module Commands

    # Run git commands in the dotfiles directory.
    #
    # This command simply passes everything passed to it on to the git
    # executable on the user's PATH.
    #
    # A basic equivalent of this command:
    #
    #     briefcase git status
    #
    # Would be:
    #
    #     cd ~/.dotfiles && git status
    class Git < Base

      # Execute a git command in the dotfiles directory. Will prompt the user
      # to create a dotfiles directory if it does not exist, which will also
      # create an empty git repository.
      def execute
        verify_dotfiles_directory_exists
        command = Escape.shell_command(@args)
        intro("Running git %s in %s", command, dotfiles_path)
        run_git_command(command)
      end

      private

      def run_git_command(command)
        $stdout.flush
        exec "cd #{dotfiles_path} && git #{command}"
      end

    end
  end
end

