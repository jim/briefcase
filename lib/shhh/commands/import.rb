require 'tempfile'

module Shhh
  module Commands
    class Import < Base

      def execute
        verify_dotfiles_directory_exists

        @path = File.expand_path(@args.first)
        raise UnrecoverableError.new("#{@path} does not exist") unless File.exist?(@path)

        intro("Importing %s into %s", @path, dotfiles_path)
        import_file
      end

      private

      def import_file
        collision = dotfile_exists?(@path)
        if !collision || overwrite_file?

          mkdir_p(dotfiles_path)
          destination = generate_dotfile_path(@path)

          if collision
            existing = Dir.glob("#{destination}.old.*").size
            sideline = "#{destination}.old.#{existing+1}"
            info "Moving %s to %s", destination, sideline
            mv(destination, sideline)
          end

          move(@path, destination)
          symlink(destination, @path)
        else
          raise CommandAborted.new('Cancelled.')
        end
      end


      def overwrite_file?
        decision = choose("#{@path} already exists as a dotfile. Do you want to replace it? Your original file will be renamed.", 'replace', 'abort') do |menu|
          menu.index = :letter
          menu.layout = :one_line
        end

        decision == 'replace'
      end

    end
  end
end
