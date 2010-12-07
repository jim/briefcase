require "open4"

def run_command(command, expected_status=0, &block)
  @output = ''
  
  responses = []
  def responses.response(regex, text)
    push([regex, text])
  end
  
  if block_given?
    block.call(responses)
  end
  
  ENV['SHHH_DOTFILES_DIR'] = dotfiles_path
  ENV['SHHH_HOME_DIR'] = home_path
  ENV['SHHH_SECRETS_PATH'] = secrets_path
  ENV['SHHH_TESTING'] = 'true'
  ENV['RUBYOPT'] = 'rubygems'
  ENV['EDITOR'] = File.expand_path('../bin/editor', File.dirname(__FILE__))
  
  full_command = "./bin/shhh #{command}"

  status = Open4.popen4(full_command) do |pid, stdin, stdout, stderr|
    while output = stdout.gets() || stderr.gets()
      puts output if ENV['SHHH_VERBOSE_TEST'] == 'true'
      @output << output
      responses.each do |response|
        regex, text = response
        stdin.write(text + "\n") if output =~ regex
      end
    end
  end
  
  exit_status = status.exitstatus
  fail("Expected exist status of #{expected_status}, got #{exit_status}") unless exit_status == expected_status
  
end