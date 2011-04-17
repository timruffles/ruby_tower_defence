class World
  include HashInitializer
  attr_accessor :actors, :tick_pause_secs, :tick_max, :publish_context, :map
  numeric_attr_accessor :tick
  defaults :tick_pause_secs => 3,
           :tick_max => 1000,
           :publish_context => -> { Publish::PublishContext.new },
           :map => -> { Map.new }
  delegate :pub, :spub, :events, :to => :publish_context
  delegate Map, :to => :map
  def run
    until round_over? do
      actors.each(&:tick)
      yield self if block_given?
      sleep tick_pause_secs if tick_pause_secs > 0
      self.tick += 1
    end
  end
  def types_in_range positioned, types, range
    within_range(positioned,population(*types),range) - [positioned]
  end
  def population *actor_types
    actors.select do |actor|
      actor_types.any? {|type| actor.class <= type }
    end
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
  def universalise
    Kernel.const_set('WorldInstance',self)
  end
end
# gives instance access to world, via top level WorldInstance const, or a personal world
module Worldly
  include Publish::Publisher
  delegate :pub, :spub, :to => :world
  def world
    @world ||= WorldInstance rescue World.new
  end
end