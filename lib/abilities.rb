class Ability
  numeric_attr_accessor :delay, :energy, :last_activated_at
  attr_accessor :actor
  include HashInitializer
  include Worldly
  def tick
    if world.tick >= last_activated_at + delay
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