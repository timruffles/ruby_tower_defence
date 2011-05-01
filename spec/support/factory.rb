class Factory
  class << self
    attr_accessor :factories
    def define name, args_proc = nil, &block
      factories[name] = [block, args_proc]
    end
    def factories
      @factories ||= {}
    end
    def create name, override_args = nil
      init, args_proc = factories[name]
      args = override_args || (args_proc ? args_proc.call : [])
      instance = name.to_s.classify.constantize.new *args
      instance.instance_exec(init) if init
      instance
    end
  end
end
def Factory name, *args
  Factory.create(name, args)
end
Factory.define(:world, -> { [:area => Area.new] })
