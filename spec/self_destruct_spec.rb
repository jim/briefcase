require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::SelfDestruct do

  before do
    create_home_directory
    create_dotfiles_directory
    @dynamic_path = File.join(dotfiles_path, 'dynamic.classified')
    @dotfile_path = File.join(dotfiles_path, 'standard')
    @dynamic_link_path = File.join(home_path, '.dynamic')
    @dotfile_link_path = File.join(home_path, '.standard')
    create_file(@dynamic_path, "dynamic content")
    create_file(@dotfile_path)    
    create_symlink(@dynamic_path, @dynamic_link_path)
    create_symlink(@dotfile_path, @dotfile_link_path)
  end

  after do
    cleanup_home_directory
    cleanup_dotfiles_directory
  end

  it "self destructs" do
    run_command('selfdestruct') do |c|
      c.response(/PERMANENTLY/, 'remove')
    end
    
    output_must_contain(/Self-destructing.../)
    file_must_not_exist(@dynamic_path)
    file_must_not_exist(@dotfile_path)
    file_must_have_moved(@dotfile_link_path, @dotfile_path)
    file_must_contain(@dynamic_link_path, "dynamic content")
    directory_must_exist(@dotfiles_path)
  end

end