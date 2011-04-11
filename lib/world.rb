class World
  include HashInitializer
  attr_accessor :tick, :actors
  attr_reader :publish_context
  default(:publish_context) { PublishContext.new }
  default(:map) { Map.new }
  delegate :pub, :spub, :events, :to => :publish_context
  delegate Map, :to => :map
  def run
    until round_over? do
      actors.each(&:tick)
      draw
      sleep 1
    end
    tick += 1
  end
  def types_in_range positioned, types, range
    within_range(positioned,types(types),range) - [positioned]
  end
  def types types
    actors.select {|a| types.include?(type) }
  end
  def tick
    @tick ||= 0
  end
  def round_over?
    tick > 1000 || players.empty?
  end
  def actors_by_coords
    actors.inject({}) do |coords,actor|
      coords[[actor.x,actor.y]] = actor
      coords
    end
  end
end
# gives instance access to world, via top level WorldInstance const, or a personal world
module Worldly
  attr_reader :world
  default(:world) { WorldInstance || World.new }
  include Publish::Publisher
  delegate :pub, :spub, :to => :world
end