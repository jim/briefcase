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