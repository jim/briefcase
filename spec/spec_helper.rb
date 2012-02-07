require 'rubygems'
require 'bundler/setup'

require 'minitest/spec'
# require 'turn/autorun/minitest'
require 'minitest/mock'

MiniTest::Unit.autorun

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'briefcase'

require 'helpers/assertions'
require 'helpers/files'
require 'helpers/stubbing'
require 'helpers/commands'
