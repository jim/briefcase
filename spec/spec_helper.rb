require 'rubygems'
require 'minitest/spec'
require 'minitest/mock'
require 'highline'
MiniTest::Unit.autorun

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'shhh'

require 'helpers/assertions'
require 'helpers/files'
require 'helpers/stubbing'

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

def stub_choose_and_return(return_value)
  @command.stub :choose do |message, *choices|
    @command.say(message)
    return_value
  end
end

$terminal = HighLine.new
class Shhh::Commands::Base
  attr_accessor :say_buffer
  def say(message)
    @say_buffer ||= []
    @say_buffer << message
  end
end
