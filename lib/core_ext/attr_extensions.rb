# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      attr_accessor_with_default sym, 0
    end
  end
  def attr_accessor_with_default sym, default = Proc.new {}
    if sym.is_a? Hash
      sym.each_pair do |k,v|
        attr_accessor_with_default(k,v)
      end
    else
      # initial getter
      define_method(sym, default.is_a?(Proc) ? default : Proc.new { default })
      setter = "#{sym}="
      define_method "#{sym}_with_default_remove=" do |to|
        class_eval do
          attr_reader sym
          alias_method sym, "#{sym}_without_default_remove="
        end
        self.send setter, to
      end
      unless instance_methods.include?(setter)
        attr_writer sym
      end
      alias_method_chain setter, 'default_remove'
    end
  end
end
