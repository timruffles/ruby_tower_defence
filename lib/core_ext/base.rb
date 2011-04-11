module CoreExt
  module Base
    class << self
      def included(into)
        class << into
          attr_accessor :extend_targets, :mixin_targets
        end
        into.send :extend, Macros
      end
    end
    module Macros
      def to_extend klass
        (extend_targets ||= []) << klass
      end
      def mixin_to klass
        (mixin_targets ||= []) << klass
      end
    end
  end
end