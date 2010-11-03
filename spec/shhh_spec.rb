require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'fileutils'
include FileUtils

def create_empty_file(path)
  File.open(path, "w") do |file|
    file.write('test')
  end
end

def file_must_exist(path)
  File.file?(path).must_equal true
end

def symlink_must_exist(path, target)
  File.exist?(path).must_equal(true)
  File.readlink(path).must_equal(target)
end

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
    
    it "renames an existing dotfile when importing a duplicate and instructed to replace it" do
      original = File.join(home_path, '.test')
      moved = File.join(dotfiles_path, 'test')
      relocated = File.join(dotfiles_path, 'test.old.1234')
      
      create_empty_file(original)
      create_empty_file(moved)
      setup_command :import, original
      
      @command.stub :choose do |message, *choices|
        @command.say(message)
        'replace'
      end
      
      @command.stub(:generate_timestamp, '1234')
      
      run_command

      output_must_contain(/Importing/, /Moving/, /already exists as a dotfile/)
      file_must_exist(moved)
      file_must_exist(relocated)
      symlink_must_exist(original, moved)
    end
  
  end
  
end
