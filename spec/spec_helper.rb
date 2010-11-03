require 'rubygems'
require 'minitest/spec'
require 'minitest/mock'
require 'highline'
MiniTest::Unit.autorun

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'shhh'

def home_path
  File.expand_path('spec_work/shhh_home', File.dirname(__FILE__))
end

def dotfiles_path
  File.expand_path('spec_work/shhh_dotfiles', File.dirname(__FILE__))
end

def setup_command(command, *args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  command_klass = "#{command.to_s.capitalize}"
  terminal_out = nil
  std_out, std_err = capture_io do
    @command = Shhh::Commands.const_get(command_klass).new(args, options)
  end
end

def run_command
  @command.run
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

def output_must_contain(*regexes)
  regexes.all? do |regex|
    buffer = @command.say_buffer
    buffer.any? do |line|
      line =~ regex
    end.must_equal(true, "Could not find #{regex} in: \n#{buffer.join("\n")}")
  end
end

class Object
  def stub(method_name, return_value=nil)
    (class << self; self; end).class_eval do
      define_method method_name do
        return_value
      end
    end
  end
end
