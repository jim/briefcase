require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Pull do
  it 'runs git pull' do
    run_command('pull')
  end
end
