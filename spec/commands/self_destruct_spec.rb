require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::SelfDestruct do

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

  it "does nothing then the user aborts"

  it "self destructs" do
    skip 
    create_file(@file_path)
    # create_symlink(@link_path, @file_path)

    run_command("selfdestruct") do |c|
      
    end

    output_must_contain(/Synchronizing dotfiles/, /Symlinking/)

    file_must_exist(@file_path)
    symlink_must_exist(@link_path, @file_path)
  end
  
  it "fails to self destruct if a secret isn't found"
  it "removes the secrets file when instructed to do so"
  it "does not remove the secrets file when told not to"

end