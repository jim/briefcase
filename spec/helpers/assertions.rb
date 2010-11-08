def directory_must_exist(path)
  File.directory?(path).must_equal(true, "Expected directory to exist at #{path}")
end

def directory_must_not_exist(path)
  File.directory?(path).must_equal(false, "Did not expect directory to exist at #{path}")
end

def file_must_exist(path)
  File.file?(path).must_equal(true, "Expected file to exist at #{path}")
end

def file_must_not_exist(path)
  File.file?(path).must_equal(false, "Expected file to not exist at #{path}")
end

def symlink_must_exist(path, target)
  File.exist?(path).must_equal(true, "Expected symlink to exist at #{path}")
  actual = File.readlink(path)
  actual.must_equal(target, "Expected symlink to #{target}, was #{actual}")
end

def symlink_must_not_exist(path)
  if File.exist?(path)
    File.file?(path).must_equal true
  end
end

def file_must_have_moved(original_path, new_path)
  file_must_exist(new_path)
  birthplace = File.open(new_path) do |file|
    file.read
  end
  birthplace.must_equal(original_path, "Expected file at #{new_path} to have been moved from #{original_path}")
end

def file_must_not_have_moved(path)
  file_must_exist(path)
  birthplace = File.open(path) { |file| file.read }
  birthplace.must_equal(path, "Did not expect file at #{path} to have been moved from #{birthplace}")
end

def git_ignore_must_include(path)
  git_ignore_path = File.join(dotfiles_path, '.gitignore')
  file_must_exist(git_ignore_path)
  ignore_contents = File.open(git_ignore_path) { |file| file.read }
  ignore_contents.must_match %r{^#{File.basename(path)}$}
end

def secret_must_be_stored(yaml_key, key, value)
  file_must_exist(secrets_path)
  @secrets = YAML.load_file(secrets_path)
  @secrets[yaml_key][key].must_equal(value)
end


def array_matches_regex(array, regex)
  array.any? do |element|
    element.gsub(/\e\[\d+m/, '') =~ regex
  end
end

def output_must_contain(*regexes)
  regexes.all? do |regex|
    array_matches_regex(@output, regex).must_equal(true, "Could not find #{regex} in: \n#{@output}")
  end
end

def output_must_not_contain(*regexes)
  regexes.any? do |regex|
    array_matches_regex(@output, regex).must_equal(false, "Found #{regex} in: \n#{@output}")
  end
end