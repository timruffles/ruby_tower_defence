class Ability
  numeric_attr_accessor :delay, :energy, :last_activated_at
  attr_accessor :actor
  include HashInitializer
  delegate :world, :to => :actor
  delegate :pub, :spub, :to => :actor
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
class Wait < Ability
  def tick
  end
end
class OtherAffecting < Ability
  attr_accessor :affects
  def format_affects who
     [case who
       when :foes
         actor.class.is_a?(Player) ? Enemy : Player
       when :friends
         actor.class
       when Class
         who
     end]
  end
end
class AreaAffect < OtherAffecting
  attr_accessor :range
  def targets
    world.types_in_range(actor,format_affects(affects),range)
  end
  def invoke
    in_range = targets
    activated unless in_range.empty?
    in_range.each do |actor|
      affect(actor)
    end
  end
end
class Targetted < OtherAffecting
  attr_accessor :range, :target
  def targets
    world.types_in_range(actor,format_affects(affects),range)
  end
  def invoke
    in_range = targets
    return if in_range.empty?
    unless in_range.include?(target)
      target = in_range.first
    end
    affect(target)
  end
end
class Heal < AreaAffect
  numeric_attr_accessor :healing
  defaults :affects, :friends
  def affect beneficary
    spub :heal, beneficary, healing, "#{actor} just healed #{beneficary} for #{healing}"
    beneficary.hps += healing
  end
end
class Melee < AreaAffect
  numeric_attr_accessor :damage
  defaults :affects, :foes
  def affect victim
    spub :melee, victim, damage, "#{actor} just struck #{victim} for #{damage}"
    dmg = damage
    victim.hps -= dmg
  end
  def range; 1; end
end
class Movement < Ability
  numeric_attr_accessor :speed
  def invoke
    actor.x -= speed
  end
  def move(x_change, y_change = 0)
    spub :moved, x, y, old_x, old_y
    old_x, old_y = x, y
    x += x_change
    y += y_change
  end
end