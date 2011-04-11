# pub sub
# verb subject object - a doing x to b
#   - <Zombie>, <Player>, :melee
# verb subject - a has changed by x, to z
#   - <Player>, :hps, -2, 10
# allows for very simple display updates, with little logic. just listen and display events
class Module
  def numeric_attr_accessor *symbs
    symbs.each do |sym|
      attr_writer sym
      define_method sym do
        iv = "@#{sym}"
        unless instance_variable_get(iv)
          instance_variable_set(iv, 0)
        end
        instance_variable_get(iv)
      end
    end
  end
end
class Array
  def random
    self.send :[], rand * (length)
  end
end
module Map
  attr_accessor :x_size, :y_size
  def within_range(from,objects,range)
    objects.select do |positioned|
      distance(from,positioned) <= range
    end
  end
  def distance a, b
    Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)
  end
  def actors_within_range(positioned,range)
    within_range(positioned,actors,range) - [positioned]
  end
  def enemies_within_range(positioned,range)
    within_range(positioned,enemies,range) - [positioned]
  end
  def players_within_range(positioned,range)
    within_range(positioned,enemies,range) - [positioned]
  end
  def right
    x_size
  end
  def left
    0
  end
  def top
    y_size
  end
  def bottom
    0
  end
end
module HashInitializer
  def initialize opts = {}
    opts.each do |key,val|
      self.send "#{key}=", val
    end
  end
end
class TowerDefence
  include HashInitializer
  include Map
  attr_accessor :tick, :actors
  def run
    until round_over? do
      actors.each(&:tick)
      draw
      sleep 1
    end
    tick += 1
  end
  def players
    actors.select {|a| a.is_a?(Player) }
  end
  def enemies
    actors.select {|a| a.is_a?(Enemy) }
  end
  def tick
    @tick ||= 0
  end
  def round_over?
    tick > 1000 || players.empty?
  end
  def pub msg
    puts msg
  end
  def actors_by_coords
    actors.inject({}) do |coords,actor|
      coords[[actor.x,actor.y]] = actor
      coords
    end
  end
  def draw
    actors_at_coords = actors_by_coords
    (0..y_size).each do |row_i|
      row = []
      (0..x_size).each do |col_i|
        at_coord = actors_at_coords[[col_i,row_i]]
        output = case at_coord
                   when nil
                     ' '
                   when Enemy
                     'E'
                   when Player
                     'P'
                 end
        row << output
      end
      puts "|#{row.join(' ')}|\n"
    end
  end
end
class Ability
  numeric_attr_accessor :delay, :energy, :last_activated_at
  attr_accessor :actor
  include HashInitializer
  def tick
    if World.tick >= last_activated_at + delay
      invoke
    end
  end
  def invoke
  end
  def activated
    last_activated_at = World.tick
  end
end
module OtherAffecting
  def targets
    World.actors_within_range(actor,range)
  end
end
module EnemyAffecting
  def targets
    # probably good to get some idea of teams in here etc
    actor.is_a?(Enemy) ? World.players_within_range(actor,range) :  World.enemies_within_range(actor,range)
  end
end
module AreaAffect
  attr_accessor :range
  def invoke
    in_range = targets
    activated unless in_range.empty?
    in_range.each do |actor|
      affect(actor)
    end
  end
end
module Targetted
  attr_accessor :range, :target
  def invoke
    in_range = targets
    return if in_range.empty?
    unless in_range.include?(target)
      target = in_range.first
    end
    affect(target)
  end
end
class Heal < Ability
  include AreaAffect
  include OtherAffecting
  def affect beneficary
    beneficary.hps += 10
    pub(beneficary,10)
  end
  def pub beneficary, dmg
    World.pub("#{actor} just healed #{beneficary} for #{dmg}")
  end
end
class Melee < Ability
  numeric_attr_accessor :damage
  include AreaAffect
  include EnemyAffecting
  def affect victim
    dmg = damage
    victim.hps -= dmg
    pub(victim,dmg)
  end
  def pub victim, dmg
    World.pub("#{actor} just hit #{victim} for #{dmg}")
  end
  def range; 1; end
end
class Movement < Ability
  numeric_attr_accessor :speed
  def invoke
    last_x = actor.x
    actor.x -= speed
    pub last_x, actor.y
  end
  def pub last_x, last_y
    World.pub("#{actor} moved from #{last_x}, #{last_y} to #{actor.x}, #{actor.y}")
  end
end
module Positioned
  numeric_attr_accessor :x, :y
end
class Actor
  attr_accessor :name, :abilities
  numeric_attr_accessor :hps, :energy, :regenerate, :recharge
  include Positioned
  include HashInitializer
  def tick_callbacks
    @tick_callbacks ||= methods.select {|method| /_on_tick$/ =~ method}
  end
  def tick
    tick_callbacks.each {|method| self.send method }
  end
  def regenerate_and_run_activity_on_tick
    self.hps += regenerate
    self.energy += recharge
    self.current_ability.tick
  end
  def current_ability
    @current_ability ||= abilities.first
  end
  def abilities= abilities
    @abilities = abilities
    @abilities.each do |ability|
      ability.actor = self
    end
  end
  def to_s
    name
  end
end
class Player < Actor
end
class Enemy < Actor
end
class Zombie < Enemy
  def self.spawn overrides = {}
    Zombie.new defaults.merge(overrides)
  end
  def self.defaults
    {:abilities => [Melee.new(:range => 1, :damage => 3),Movement.new(:speed => 1)]}
  end
  def current_ability
    abilities.random
  end
end

World = TowerDefence.new :x_size => 12, :y_size => 10
World.actors = [
  Player.new(:x => 3, :y => 5, :name => 'Bob', :abilities => [Heal.new(:range => 2)]),
  Player.new(:x => 7, :y => 10, :name => 'Frank', :abilities => [Melee.new(:range => 1, :damage => 3)]),
  Zombie.spawn(:x => World.right, :y => 3, :name => 'Rotten Policeman'),
  Zombie.spawn(:x => World.right, :y => 5, :name => 'Stinky Skank'),
  Zombie.spawn(:x => World.right, :y => 6, :name => 'Putrid Politican')
]
World.run