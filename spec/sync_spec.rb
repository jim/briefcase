require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Sync do

  before do
    create_home_directory
    create_dotfiles_directory

    @file_path = File.join(dotfiles_path, 'test')
    @link_path = File.join(home_path, '.test')
  end

  after do
    cleanup_home_directory
    cleanup_dotfiles_directory
  end

  it "creates links to existing files" do
    create_file(@file_path)

    run_command("sync")

    output_must_contain(/Synchronizing dotfiles/, /Symlinking/)

    file_must_exist(@file_path)
    symlink_must_exist(@link_path, @file_path)
  end

end