require_relative 'core_ext'
module Publish
  class PublishContext
    attr_accessor :events
    attr_accessor_with_default(:events) { [] }
    def publish event, subject_class, subject, *args
      events.push([subject_class,subject,event].concat(args))
    end
    alias :pub :publish
    def scoped_publish event
      pub(event,self.class,self,*args)
    end
    alias :spub :scoped_publish
  end
  module Publisher
    class << self
      def included(into)
        into.send :extend, Macros
      end
    end
    module Macros
      def attr_accessor_evented *symbs
        symbs.each do |sym|
          attr_accessor sym
          define_method "#{sym}_with_publish=" do |val,&block|
            pre = self.send sym
            self.send "#{sym}_without_publish=", val, &block
            pub self, :change, sym, val, pre
          end
          alias_method_chain "#{sym}=", 'publish'
        end
      end
    end
  end
end