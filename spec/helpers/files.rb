require 'fileutils'
include FileUtils

def home_path
  File.expand_path('../spec_work/shhh_home', File.dirname(__FILE__))
end

def dotfiles_path
  File.expand_path('../spec_work/shhh_dotfiles', File.dirname(__FILE__))
end

def secrets_path
  File.expand_path('../spec_work/shhh_home/.shhh_secrets', File.dirname(__FILE__))
end

def create_home_directory
  mkdir_p(home_path)
end

def cleanup_home_directory
  rm_rf(home_path)
end

def create_git_repo
  mkdir_p(File.join(dotfiles_path, '.git'))
end

def create_dotfiles_directory
  mkdir_p(dotfiles_path)
end

def cleanup_dotfiles_directory
  rm_rf(dotfiles_path)
end

def create_empty_file(path)
  File.open(path, "w") do |file|
    file.write(path)
  end
end