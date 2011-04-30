class AI::Player < AI::Base
  def tick
    attack favoured_target
  end
  def favoured_target
    closest world.population(Zombie)
  end
  def attack target
    actor.invoke :ranged, target
  end
end