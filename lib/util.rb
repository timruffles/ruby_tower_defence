module HashInitializer
  def initialize opts = {}
    self.class.default_initialisers.merge(opts).each do |key,val|
      self.send "#{key}=", val
    end
  end
  class << self
    def included(into)
      into.send :extend, Macros
    end
  end
  module Macros
    # rewrite to an internal default hash in HashInitialiser
    def defaults hash
      (@defaults ||= {}).merge!(hash)
      hash.each do |sym,val|
        eval <<-META
          def #{sym}
            @#{sym} ||= @defaults[sym]
          end
        META
      end
    end
    def default_initialisers
      @defaults
    end
  end
end
