module CoreExt::Delegate
  module Delegate
    include CoreExt::Base
    mixin_to = Module
    def delegate *args
      opts = args.pop
      if args.first.is_a?(Module)
        delegate_module(mod,opts[:to])
      else
        delegate_array(args,opts[:to])
      end
    end
    def delegate_array args, to
      args.each do |sym|
        define_method sym do *args
          self.send(to).send(sym,*args)
        end
      end
    end
    def delegate_module mod, to
      delegate_array mod.methods - Module.methods, to
    end
  end
end
