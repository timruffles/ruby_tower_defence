# extensions to save time configuring a class' instance vars
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      instance_eval <<-META
        def #{sym}
          @#{sym} ||= 0
        end
      META
    end
  end
end
