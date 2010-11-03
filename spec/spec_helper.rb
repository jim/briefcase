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
require 'helpers/commands'