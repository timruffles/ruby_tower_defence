require_relative 'core_ext'
module Publish
  class PublishContext
    attr_accessor :events
    def events
      @events ||= []
    end
    def event *args
      events.push(args)
    end
  end
  module Publisher
    def publish event, subject_class, subject, *args
      publish_context.event([subject_class,subject,event].concat(args))
    end
    alias :pub :publish
    def scoped_publish event, *args
      pub(event,self.class,self,*args)
    end
    alias :spub :scoped_publish
    class << self
      def included(into)
        into.send :extend, Macros
      end
    end
    module Macros
      def attr_writer_evented *symbs
        symbs.each do |sym|
          define_method "#{sym}_with_publish=" do |val,&block|
            pub self, :change, sym, val
            self.send "#{sym}_without_publish=", val, &block
          end
          attr_writer sym unless instance_methods.include?("sym=".to_sym)
          alias_method_chain "#{sym}=", 'publish'
        end
      end
    end
  end
end