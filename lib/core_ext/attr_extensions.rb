# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      default sym, 0
    end
  end
  def default iv, value = nil, &value_proc
    define_method iv do
      iv = "@#{sym}"
      unless instance_variable_get(iv)
        instance_variable_set(iv, value || value_proc.call)
      end
      instance_variable_get(iv)
    end
  end
end