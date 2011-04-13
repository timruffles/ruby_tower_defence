class World
  include HashInitializer
  attr_accessor :actors, :tick_pause_secs, :tick_max
  numeric_attr_accessor :tick
  attr_reader :publish_context
  default(:publish_context) { PublishContext.new }
  default(:map) { Map.new }
  default :tick_pause_secs => 3,
          :tick_max => 1000

  delegate :pub, :spub, :events, :to => :publish_context
  delegate Map, :to => :map
  def run
    until round_over? do
      actors.each(&:tick)
      yield self if block_given?
      sleep tick_pause_secs if tick_pause_secs > 0
      tick += 1
    end
  end
  def types_in_range positioned, types, range
    within_range(positioned,types(types),range) - [positioned]
  end
  def population *actor_types
    actors.select {|a| actor_types.include?(a.class) }
  end
  def round_over?
    tick > tick_max || population(Player).empty? || population(Enemy).empty?
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