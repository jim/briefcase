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
      run_command("import .test")
      output_must_contain(/does not exist/)
    end
    
    it "imports a dotfile" do
      original = File.join(home_path, '.test')
      moved = File.join(dotfiles_path, 'test')
      
      create_empty_file(original)

      run_command("import #{original}")

      output_must_contain(/Importing/, /Moving/)
      file_must_exist(moved)
      symlink_must_exist(original, moved)
    end
    
    it "imports a dynamic dotfile" do
      original = File.join(home_path, '.test')
      moved = File.join(dotfiles_path, 'test')
      erb = File.join(dotfiles_path, 'test.erb')
      
      create_empty_file(original)

      run_command("import #{original} --erb")

      output_must_contain(/Importing/, /Moving/, /Creating ERB version at/)
      file_must_exist(moved)
      file_must_exist(erb)
      symlink_must_exist(original, moved)
    end
    
    describe "collision handling" do
      
      before do
        @original = File.join(home_path, '.test')
        @moved = File.join(dotfiles_path, 'test')
        @relocated = File.join(dotfiles_path, 'test.old.1234')
      
        create_empty_file(@original)
        create_empty_file(@moved)

      end
      
      it "renames an existing dotfile when importing a duplicate and instructed to replace it" do
      
        run_command("import #{@original} --erb") do |c|
          c.response(/Do you want to replace it\?/, 'replace')
        end

        output_must_contain(/Moving/, /Symlinking/, /already exists as a dotfile/)
        file_must_exist(@moved)
        file_must_exist(@relocated)
        symlink_must_exist(@original, @moved)
      end
    
      it "does not modify an existing dotfile when instructed not to" do

        run_command("import #{@original} --erb") do |c|
          c.response(/Do you want to replace it\?/, 'skip')
        end

        output_must_contain(/already exists as a dotfile/)
        output_must_not_contain(/Moving/, /Symlinking/)
        file_must_not_have_moved(@moved)
        file_must_not_exist(@relocated)
        symlink_must_not_exist(@original)
      end
      
    end
  
  end
  
end
