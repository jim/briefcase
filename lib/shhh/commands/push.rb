module Shhh
  module Commands
    class Push < Base
      def execute
        intro "Pushing #{dotfiles_path} to remote origin"
        remotes = `cd #{dotfiles_path} && git remote`.split("\n")

        unless remotes.include?('origin')
          choice = choose("The repository at #{dotfiles_path} doesn't have a remote named origin. Do you want to create one on GitHub?", 'create', 'abort') do |menu|
            menu.index = :letter
            menu.layout = :one_line
          end
          if choice == 'abort'
            raise CommandAborted.new('Can not push without remote origin')
          else
            user = `git config github.user`.strip
            token = `git config github.token`.strip
            if user == '' || token == ''
              raise UnrecoverableError.new('Could not load your GitHub credentials using git config')
            else
              auth = "#{user}/token:#{token}"
            end
            # verify the repo doesn't exist
            # create repo
            # add a readme if there isn't one
            # add remote
            # finally push
          end
        end
        puts `cd #{dotfiles_path} && git push origin`
      end
    end
  end
end
