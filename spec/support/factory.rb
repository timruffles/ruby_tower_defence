class Factory
  class << self
    attr_accessor :factories
    def define name, constructor_args = nil, &block
      factories[name] = [block, constructor_args]
    end
    def factories
      @factories ||= {}
    end
    def create name
      init, args_proc = factories[name]
      instance = name.to_s.classify.constantize.new *args_proc.() if args_proc
      instance.instance_exec(init) if init
      instance
    end
  end
end
def Factory name
  Factory.create(name)
end
Factory.define(:world, -> { [:area => Area.new] })
