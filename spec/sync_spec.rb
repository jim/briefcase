require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Sync do

  before do
    create_home_directory
    create_dotfiles_directory
    create_git_repo

    @static_path = File.join(dotfiles_path, 'static')
    @dynamic_path = File.join(dotfiles_path, 'dynamic.erb')
    @generated_path = File.join(dotfiles_path, 'dynamic')
  end

  after do
    cleanup_home_directory
    cleanup_dotfiles_directory
    # cleanup_editor_responses
  end

  it "creates static versions of all dynamic files" do
    
    content = <<-FILE
setting: value
FILE
    
    create_file(@static_path, content)
    create_file(@dynamic_path, content)

    run_command("sync")

    file_must_exist(@static_path)
    file_must_exist(@dynamic_path)
    file_must_exist(@generated_path)

  end


end
