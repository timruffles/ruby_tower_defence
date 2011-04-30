require_relative 'core_ext'
module Publish
  class PublishContext
    attr_accessor :messages, :subs
    defaults :subs => -> { Hash.new {|hash,key| hash[key] = []} },
             :messages => -> {[]}
    def pub event, subject_class, subject, *args
      messages.push([event,subject_class,subject].concat(args))
      to_notify = subs[event] + subs[[event,subject_class]] + subs[[event,subject]]
      to_notify.each do |listener, callback, filter|
        if !filter || filter == args
          listener.send callback, event, subject_class, subject, *args
        end
      end
    end
    def sub event, callback, subject_class = nil, subject = nil, args = nil
      raise ArgumentError.new "Sub requires: event only, or either subject class or subject" if !event || subject_class && subject
      location = subject || subject_class ? subs[[event,subject_class || subject]] : subs[event]
      location.push [self,callback,args]
    end
    def unsub event, callback, subject_class = nil, subject = nil, args = nil
      raise ArgumentError.new "Unsub requires: event only, or either subject class or subject" if !event || subject_class && subject
      subs[event] + subs[[event,subject || subject_class]].delete_if do |_,_,filter|
        !filter || filter == args
      end
    end
  end
  module Publisher
    # scoped publish
    def spub event, *args
      pub event,self.class,self,*args
    end
    delegate :pub, :sub, :to => :publish_context
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