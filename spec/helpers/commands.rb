require "open3"

def run_command(command, &block)
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
  ENV['RUBYOPT'] = 'rubygems'
  
  full_command = "./bin/shhh #{command}"

  Open3.popen3(full_command) do |stdin, stdout, stderr|
    while output = stdout.gets()
      @output << output
      responses.each do |response|
        regex, text = response
        stdin.write(text + "\n") if output =~ regex
      end
    end
  end
  
end