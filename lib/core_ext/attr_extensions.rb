# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      default sym, 0
    end
  end
  def around_alias method, feature
    method, suffix = /=$/.match(method).to_a
    alias_method "#{method}_without_#{feature}#{suffix}", method
    alias_method method, "#{method}_with_#{feature}#{suffix}"
  end
  def default iv, value,
    define_method iv do
      iv = "@#{sym}"
      unless instance_variable_get(iv)
        instance_variable_set(iv, value_proc.call)
      end
      instance_variable_get(iv)
    end
  end
end