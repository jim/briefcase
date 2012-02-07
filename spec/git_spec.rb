require 'spec_helper'

describe Briefcase::Commands::Git do

  before do
    create_dotfiles_directory
    create_git_repo
  end

  after do
    cleanup_dotfiles_directory
  end

  it "creates links to existing files" do
    create_file(dotfiles_path + '/test.txt', 'testing git integration')
    run_command("git status")

    output_must_contain(/Running git status/)
  end

end
