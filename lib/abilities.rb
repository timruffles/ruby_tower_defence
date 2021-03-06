class Ability
  numeric_attr_accessor :delay, :energy, :last_activated_at
  attr_accessor :actor
  include HashInitializer
  delegate :world, :to => :actor
  delegate :pub, :spub, :to => :actor
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
  def in_range? target
    actor.distance_to(target) <= range
  end
  def invoke target
    affect(target) if in_range? target
  end
end
class Heal < Targetted
  numeric_attr_accessor :healing
  defaults :affects, :friends
  def affect beneficary
    spub :heal, beneficary, healing, "#{actor} just healed #{beneficary} for #{healing}"
    beneficary.hps += healing
  end
end
class Melee < Targetted
  numeric_attr_accessor :damage
  def affect victim
    spub :melee, victim, damage, "#{actor} just struck #{victim} for #{damage}"
    dmg = damage
    victim.hps -= dmg
  end
  def range; 1; end
end
class Ranged < Targetted
  numeric_attr_accessor :damage
  def affect victim
    spub :ranged, victim, damage, "#{actor} just shot #{victim} for #{damage}"
    dmg = damage
    victim.hps -= dmg
  end
  def range; 3; end
end
class Movement < Ability
  numeric_attr_accessor :speed
  def invoke towards
    if @towards != towards
      @towards = towards
      @path = world.find_path actor.point, towards
    end
    next_move = @path.pop
    old = actor.point
    actor.point = next_move
    spub :moved, actor.point, old unless next_move == @towards
  end
end