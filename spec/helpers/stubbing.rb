def stub_editor_response(file, text)
  response_file = file.gsub(/\//, '_')
  mkdir_p(editor_responses_path)
  File.open(File.join(editor_responses_path, response_file), 'w') do |file|
    file.write(text)
  end
end

def cleanup_editor_responses
  rm_rf(editor_responses_path)
end

class Object
  def stub(method_name, return_value=nil, &block)
    (class << self; self; end).class_eval do
      define_method method_name do |*args|
        if block_given?
          block.call(*args)
        else
          return_value          
        end
      end
    end
  end
end