require_relative 'base'
module CoreExt::Delegate
  include CoreExt::Base
  to_extend Module
  def delegate *args, opts
    if args.first.is_a?(Class)
      delegate_class(mod,opts[:to])
    else
      delegate_array(args,opts[:to])
    end
  end
  def delegate_array args, to
    args.each do |sym|
      define_method sym do |*args|
        self.send(to).send(sym,*args)
      end
    end
  end
  def delegate_class klass, to
    delegate_array klass.methods - Class.methods, to
  end
end
