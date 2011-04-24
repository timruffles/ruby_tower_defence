class AI
  attr_accessor :actor
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
    approach_kill self.current_target ||= favoured_target
  end
  def approach_kill target
    if in_range? current_target
      attack current_target
    else
      move.towards current_target
    end
  end
  def favoured_target
    closest
  end
end
class PlayerAI
  def tick
    self.current_target ||= closest
    attack current_target
  end
end
