require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Generate do

  describe "with an existing dotfiles directory" do

    before do
      create_dotfiles_directory
      create_home_directory
    end
  
    after do
      cleanup_dotfiles_directory
      cleanup_home_directory
    end
  
    it "generates a static version of a dynamic dotfile" do
      static_path = File.join(dotfiles_path, 'test')
      dynamic_path = File.join(dotfiles_path, 'test.erb')

      create_secrets('test' => {:email => 'google@internet.com'})      
      create_file dynamic_path, <<-TEXT
username: # shhh(:email)
TEXT
      
      run_command("generate")
      
      output_must_contain(/Generating/)
      file_must_contain static_path, <<-TEXT
username: google@internet.com
TEXT
    end
  
  end

end