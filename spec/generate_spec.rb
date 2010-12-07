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
      dynamic_path = File.join(dotfiles_path, 'test.dynamic')

      create_secrets('test' => {:email => 'google@internet.com'})      
      create_file dynamic_path, <<-TEXT
username: # shhh(:email)
favorite_color: blue
TEXT
      
      run_command("generate")
      
      output_must_contain(/Generating/, /Loading existing secrets/, /Restoring secret value/)
      
      file_must_contain static_path, <<-TEXT
username: google@internet.com
favorite_color: blue
TEXT
    end

    it "create a secrets file and adds discovered secrets to it" do
      static_path = File.join(dotfiles_path, 'test')
      dynamic_path = File.join(dotfiles_path, 'test.dynamic')

      create_file dynamic_path, <<-TEXT
username: # shhh(:email)
TEXT
      
      run_command("generate")
      
      output_must_contain(/Generating/, /Secret missing for key: email/)
      
      file_must_contain static_path, <<-TEXT
username: # shhh(:email)
TEXT

      secret_must_be_stored('test', :email, '')
    end
    
    it "adds discovered secrets to the secrets file without values" do
      static_path = File.join(dotfiles_path, 'test')
      dynamic_path = File.join(dotfiles_path, 'test.dynamic')

      create_file dynamic_path, <<-TEXT
username: # shhh(:email)
TEXT
      create_secrets
      
      run_command("generate")
      
      output_must_contain(/Generating/, /Secret missing for key: email/)
      
      file_must_contain static_path, <<-TEXT
username: # shhh(:email)
TEXT

      secret_must_be_stored('test', :email, '')
    end
  
  end

end