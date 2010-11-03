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
  birthplace = File.open(path) do |file|
    file.read
  end
  birthplace.must_equal(path, "Did not expect file at #{path} to have been moved from #{birthplace}")
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