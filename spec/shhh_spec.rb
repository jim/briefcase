require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh do
  
  before do
    setup_work_directories
  end

  after do
    cleanup_work_directories
  end
  
  describe Shhh::Commands::Import do
  
    it "does not import a nonexistent dotfile" do
      setup_command :import, '.test'
      run_command
      output_must_contain(/does not exist/)
    end
    
    it "imports a dotfile" do
      original = File.join(home_path, '.test')
      moved = File.join(dotfiles_path, 'test')
      
      setup_command :import, original
      create_empty_file(original)

      run_command

      output_must_contain(/Importing/, /Moving/)
      file_must_exist(moved)
      symlink_must_exist(original, moved)
    end
    
    describe "collision handling" do
      
      before do
        @original = File.join(home_path, '.test')
        @moved = File.join(dotfiles_path, 'test')
        @relocated = File.join(dotfiles_path, 'test.old.1234')
      
        create_empty_file(@original)
        create_empty_file(@moved)
        setup_command :import, @original
      end
      
      it "renames an existing dotfile when importing a duplicate and instructed to replace it" do
        stub_choose_and_return('replace')
        @command.stub(:generate_timestamp, '1234')
      
        run_command

        output_must_contain(/Moving/, /Symlinking/, /already exists as a dotfile/)
        file_must_exist(@moved)
        file_must_exist(@relocated)
        symlink_must_exist(@original, @moved)
      end
    
      it "does not modify an existing dotfile when instructed not to" do
        stub_choose_and_return('skip')
      
        run_command

        output_must_contain(/already exists as a dotfile/)
        output_must_not_contain(/Moving/, /Symlinking/)
        file_must_not_have_moved(@moved)
        file_must_not_exist(@relocated)
        symlink_must_not_exist(@original)
      end
      
    end
  
  end
  
end
