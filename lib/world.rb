Geo = Geometry
class World
  include HashInitializer
  include Publish::Publisher
  attr_accessor :actors, :tick, :tick_pause_secs, :tick_max, :publish_context, :area
  numeric_attr_accessor :tick
  defaults :tick_pause_secs => 1,
           :tick_max => 1000,
           :publish_context => -> { Publish::PublishContext.new },
           :actors => []
  delegate AreaInterface, :to => :area
  def initialize_with_setup opts = {}
    initialize_without_setup opts
    area.world = self
  end
  alias_method_chain :initialize, 'setup'
  def run
    sub :moved, :update_actor_position
    register_actor_positions
    until round_over? do
      actors.each(&:tick)
      yield self if block_given?
      sleep tick_pause_secs if tick_pause_secs > 0
      area.tick
      self.tick += 1
    end
  end
  def register_actor_positions
     actors.each {|actor| at_coords[actor.point].add actor }
  end
  def update_actor_position _,_,subject,new_pos,old_pos
    at_coords[old_pos].delete subject
    at_coords[new_pos].add subject
  end
  def living
    actors.reject(&:dead?)
  end
  def population *actor_types
    living.select do |actor|
      actor_types.any? {|type| actor.class <= type }
    end
  end
  def types_in_range positioned, types, range
    within_range(positioned,population(*types),range) - [positioned]
  end
  def round_over?
    tick > tick_max || population(Player).empty? || population(Enemy).empty?
  end
  def universalise
    Kernel.const_set('WorldInstance',self)
  end
end
# gives instance access to world, via top level WorldInstance const, or a personal world
module Worldly
  include Publish::Publisher
  delegate :publish_context, :to => :world
  def world
    @world = WorldInstance if WorldInstance
    @world || World.new
  end
end
class Point
  numeric_attr_accessor :x, :y
  def initialize x = 0, y = 0
    @x = x
    @y = y
  end
  def to_a
    [x,y]
  end
  def == to
    to.x == x && to.y == y
  end
  alias :eql? :==
  def hash
    "#{x},#{y}".hash
  end
  def to_s
    "Point(#{x},#{y})"
  end
end
module Positioned
  attr_accessor :point
  delegate :x, :x=, :y, :y=, :to => :point
  def distance_to positioned
    (x - positioned.x).abs + (y - positioned.y).abs
  end
  def point
    @point ||= Point.new(0,0)
  end
end
def p x = 0, y= 0; Point.new(x,y); end
