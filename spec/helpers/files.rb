require 'fileutils'
include FileUtils

SPEC_ROOT = "/tmp/shhh_spec_work"

def home_path
  File.expand_path('shhh_home', SPEC_ROOT)
end

def dotfiles_path
  File.expand_path('shhh_dotfiles', SPEC_ROOT)
end

def secrets_path
  File.expand_path('.shhh_secrets', home_path)
end

def editor_responses_path
  File.expand_path('shhh_editor_responses', SPEC_ROOT)
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

def create_secrets(hash={})
  File.open(secrets_path, "w") do |file|
    file.write(hash.to_yaml)
  end
end

def cleanup_dotfiles_directory
  rm_rf(dotfiles_path)
end

def create_file(path, text='')
  File.open(path, "w") do |file|
    file.write(text)
  end
end

def create_trackable_file(path)
  create_file(path, path)
end
