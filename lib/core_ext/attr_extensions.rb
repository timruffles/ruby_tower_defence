# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      attr_reader_with_default sym, 0
    end
  end
  def attr_reader_with_default sym, value = nil, &value_proc
    if sym.is_a? Hash
      sym.each_pair {|k,v| attr_reader_with_default(k,v)}
    else
      iv = "@#{sym}"
      setter = "#{sym}="
      define_method sym do
        puts iv, instance_variable_get(iv).nil?
        if instance_variable_get(iv).nil?
          val = value.is_a?(Proc) ? value.() : value.nil? ? value_proc.call : value
          puts "b4 #{instance_variable_get(iv).nil?}, #{val}"
          respond_to?(setter) ? self.send(setter, val) : instance_variable_set(iv,val)
          puts "after #{instance_variable_get(iv)}, #{val}"
        end
        instance_variable_get(iv)
      end
    end
  end
end