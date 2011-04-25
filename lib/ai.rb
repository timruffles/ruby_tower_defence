class AI
  attr_accessor :actor, :current_target
  delegate :world, :to => :actor
  def initialize actor
    self.actor = actor
  end
  def weakest actors
    actors.sort {|a,b| a.hps <=> b.hps }.first
  end
  def closest actors
    actors.sort {|a,b| distance_to(a) <=> distance_to(b) }.first
  end
end
class ZombieAI < AI
  def tick
    self.current_target = nil if current_target && current_target.dead?
    approach_kill self.current_target ||= favoured_target
  end
  def approach_kill target
    # TODO need to query classes of attack for range
    # eg - can i use any ability to hurt them at this range?
    if actor.distance_to(current_target) <= 1
      attack current_target
    else
      actor.invoke :movement, current_target
    end
  end
  def favoured_target
    closest world.population(Player)
  end
  def attack target
    actor.invoke :melee, target
  end
end
class PlayerAI < AI
  def tick
    self.current_target = nil if current_target && current_target.dead?
    self.current_target ||= closest world.population(Zombie)
    attack current_target
  end
  def attack target
    actor.invoke :ranged, target
  end
end
