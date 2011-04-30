# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      defaults sym => 0
    end
  end
  def delegate_with_module klass, *args, to
    if klass.is_a?(Class) || klass.is_a?(Module)
      delegate_without_module(*klass.instance_methods - Object.instance_methods,to)
    else
      delegate_without_module klass, *args, to
    end
  end
  alias_method_chain :delegate, 'module'
  def method_takes_hash method
    define_method "#{method}_with_hash" do |*args|
      if args.first.is_a?(Hash)
        args.first.each {|k,v| self.send "#{method}_without_hash", k, v }
      else
        self.send "#{method}_without_hash", *args
      end
    end
    alias_method_chain method, 'hash'
  end
  def defaults key, value
    iv = "@#{key}"
    define_method key do
      # use instance_exec as we don't want the self yielded from ins..eval
      val = value.is_a?(Proc) ? instance_exec(&value) : value
      instance_variable_get(iv) || instance_variable_set(iv,val)
    end
  end
  method_takes_hash :defaults
end
