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
class OtherAffecting < Ability
  attr_accessor :affects
  def targets
    world.types_in_range(actor,format_affects(affects))
  end
  def format_affects classes
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
  end
end
class AreaAffect < OtherAffecting
  attr_accessor :range
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
  attr_reader_with_default :affects, :friends
  def affect beneficary
    spub :heal, beneficary, healing, "#{actor} just healed #{beneficary} for #{healing}"
    beneficary.hps += healing
  end
end
class Melee < AreaAffect
  numeric_attr_accessor :damage
  attr_reader_with_default :affects, :foes
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