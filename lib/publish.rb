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
        if !filter || filter.zip(args).all? {|a,b| a.nil? || a == b}
          listener.send callback, subject_class, subject, *args
        end
      end
    end
    def pluck_messages
      msgs = messages
      self.messages = []
      msgs
    end
  end
  module Publisher
    # scoped publish
    def spub event, *args
      pub event,self.class,self,*args
    end
    delegate :pub, :subs, :to => :publish_context
    # filter args - matches on == or nil, so [nil,nil,10] matches [:foo, :bar, 10]
    def sub event, callback, subject_or_class = nil, args = nil
      location(event,subject_or_class).push [self,callback,args]
    end
    def unsub event, callback, subject_or_class = nil, args = nil
      subs[event] + subs[[event,subject_or_class]].delete_if do |_,_,filter|
        !filter || filter.zip(args).all? {|a,b| a.nil? || a == b}
      end
    end
    private
    def location event, subject_or_class = nil
      subject_or_class ? subs[[event,subject_or_class]] : subs[event]
    end
  end
  module AttrWriterEvented
    def initialize *args
      run_callbacks :initialize do
        super
      end
    end
    def self.included(into)
      into.instance_exec do
        extend Publish::Macros
        include ActiveSupport::Callbacks
        define_callbacks :initialize
        define_method :enable_attr_writer_evented do
           @attr_writer_evented_enabled = true
        end
        set_callback :initialize, :after, :enable_attr_writer_evented
      end
    end
  end
  module Macros
    def attr_writer_evented *symbs
      symbs.each do |sym|
        define_method :"#{sym}_with_publish=" do |val,&block|
          current = self.send(sym)
          spub :change, sym, val, current if @attr_writer_evented_enabled
          self.send :"#{sym}_without_publish=", val, &block
        end
        attr_writer sym unless instance_methods.include?("sym=".to_sym)
        alias_method_chain "#{sym}=", 'publish'
      end
    end
  end
end