require 'minitest/spec'
require 'minitest/mock'

MiniTest::Unit.autorun

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'briefcase'

require 'helpers/assertions'
require 'helpers/files'
require 'helpers/stubbing'
require 'helpers/commands'
