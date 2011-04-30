class AI::Base
  attr_accessor :actor, :current_target
  delegate :world, :to => :actor
  def initialize actor
    self.actor = actor
  end
  def weakest actors
    actors.sort {|a,b| a.hps <=> b.hps }.first
  end
  def closest actors
    actors.sort {|a,b| actor.distance_to(a) <=> actor.distance_to(b) }.first
  end
end
