require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'fileutils'
include FileUtils

describe Shhh do
  
  before do
    setup_work_directories
  end

  after do
    cleanup_work_directories
  end
  
  describe Shhh::Commands::Import do
  
    it "should not import a nonexistent dotfile" do
      execute :import, 'one'
      output_must_contain /does not exist/
    end
  
  end
  
end
