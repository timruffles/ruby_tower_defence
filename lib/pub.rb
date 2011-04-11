require_relative 'core_ext'
module Publish
  class PublishContext
    attr_accessor :events
    default :events {[]}
    def publish event, subject_class, subject, *args
      events.push([subject_class,subject,event].concat(args))
    end
    alias :pub :publish
    def scoped_publish event
      pub(event,self.class,self,*args)
    end
    alias :spub :scoped_pub
  end
  module Publisher
    delegate :pub, :spub, :to => World.publish_context
    class << self
      def evented_accessor *symbs
        symbs.each do |sym|
          mutator = "#{sym}="
          define_method "#{sym}_with_publish=" do |val|
            pre = self.send sym
            self.send "sym_without_publish=", val
            pub self, :change, sym, val, pre
          end
          around_alias mutator, 'publish'
        end
      end
    end
  end
end