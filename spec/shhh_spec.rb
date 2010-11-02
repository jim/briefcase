require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'fileutils'
require 'highline'
include FileUtils

def home_path
  File.expand_path('spec_work/shhh_home', File.dirname(__FILE__))
end

def dotfiles_path
  File.expand_path('spec_work/shhh_dotfiles', File.dirname(__FILE__))
end

def execute(command, *args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  command_klass = "#{command.to_s.capitalize}"
  terminal_out = nil
  std_out, std_err = capture_io do
    @output = Shhh::Commands.const_get(command_klass).new(args, options).say_buffer
  end
end

def setup_work_directories
  mkdir_p(home_path)
  mkdir_p(dotfiles_path)
  Shhh.home_path = home_path
  Shhh.dotfiles_path = dotfiles_path
end

def cleanup_work_directories
  rm_rf(home_path)
  rm_rf(dotfiles_path)
end

$terminal = HighLine.new

class Shhh::Commands::Base
  attr_accessor :say_buffer
  def say(message)
    @say_buffer ||= []
    @say_buffer << message.gsub(/\e\[\d+m/, '')
  end
end

def output_must_contain(regex_or_string)
  @output.any? do |line|
    line =~ regex_or_string
  end.must_equal(true, "Could not find #{regex_or_string} in: \n#{@output.join("\n")}")
end

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
