require_relative 'core_ext'
module Publish
  class PublishContext
    attr_accessor :events
    attr_reader_with_default(:events) { [] }
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
      def evented_accessor *symbs
        symbs.each do |sym|
          mutator = "#{sym}="
          define_method "#{sym}_with_publish=" do |val|
            pre = self.send sym
            self.send "#{sym}_without_publish=", val
            pub self, :change, sym, val, pre
          end
          alias_method_chain mutator, 'publish'
        end
      end
    end
  end
end