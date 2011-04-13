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
      define_method sym do
        unless instance_variable_get(iv)
          instance_variable_set(iv, value.is_a?(Proc) ? value.() : value.nil? ? value_proc.call : value)
        end
        instance_variable_get(iv)
      end
    end
  end
end