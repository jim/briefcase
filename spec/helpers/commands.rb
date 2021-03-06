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

  ENV['BRIEFCASE_DOTFILES_PATH'] = dotfiles_path
  ENV['BRIEFCASE_HOME_PATH'] = home_path
  ENV['BRIEFCASE_SECRETS_PATH'] = secrets_path
  ENV['BRIEFCASE_TESTING'] = 'true'
  ENV['RUBYOPT'] = 'rubygems'
  ENV['BRIEFCASE_EDITOR'] = File.expand_path('../bin/editor', File.dirname(__FILE__))

  full_command = "./bin/briefcase #{command}"
  full_command << " --trace" if ENV['BRIEFCASE_TEST_TRACE']

  status = Open4.popen4(full_command) do |pid, stdin, stdout, stderr|
    while output = stdout.gets() || stderr.gets()
      puts output if ENV['BRIEFCASE_VERBOSE_TEST']
      @output << output
      responses.each do |response|
        regex, text = response
        stdin.write(text + "\n") if output =~ regex
      end
    end
  end

  exit_status = status.exitstatus
  unless exit_status == expected_status
    puts "\n" + @output + "\n" if ENV['BRIEFCASE_TEST_TRACE']
    fail("Expected exist status of #{expected_status}, got #{exit_status}")
  end

end
