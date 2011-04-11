class Ability
  numeric_attr_accessor :delay, :energy, :last_activated_at
  attr_accessor :actor
  include HashInitializer
  delegate :world, :to => :actor
  def tick
    if world.tick >= last_activated_at + delay
      invoke
    end
  end
  def invoke
  end
  def activated
    last_activated_at = world.tick
  end
end
module OtherAffecting
  module Macros
    def affects classes
      affects = []
      classes.each do |who|
        affects << case who
                     when Class
                       who
                     when :foes
                       actor.class.is_a?(Player) ? Enemy : Player
                     when :friends
                       actor.class
                   end
      end
      default :affects, affects
    end
  end
  macros Macros
  def targets
    world.types_in_range(actor,affects)
  end
end
module AreaAffect
  include OtherAffecting
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
  include OtherAffecting
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
  affects :friends
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
  affects :foes
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
  default(:position) { Position.new(0,0) }
  def invoke
    actor.x -= speed
  end
  def move(x_change, y_change = 0)
    old_x, old_y = x, y
    x += x_change
    y += y_change
    spub :moved, x, y, old_x, old_y
  end
end