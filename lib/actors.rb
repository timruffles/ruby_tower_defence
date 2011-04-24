class Actor
  include HashInitializer
  include Positioned
  include Worldly
  include Publish::Publisher

  attr_accessor :name
  attr_reader :dead
  numeric_attr_accessor :hps, :energy, :regenerate, :recharge
  attr_writer_evented :energy, :hps, :dead
  defaults :dead, false

  def tick_callbacks
    @tick_callbacks ||= methods.select {|method| /_on_tick$/ =~ method}
  end
  def tick
    tick_callbacks.each {|method| self.send method } unless dead
  end
  def regenerate_and_run_activity_on_tick
    self.hps += self.regenerate
    self.energy += self.recharge
    self.current_ability.tick
  end
  def hps_with_death= val
    dead = true if val <= 0
    hps_without_death = val
  end
  alias_method_chain :hps=, 'death'
  def current_ability
    @current_ability ||= Wait.new
  end
  def abilities
    []
  end
  def abilities= abilities
    @abilities = abilities
    @abilities.each do |ability|
      puts ability.inspect
      ability.actor = self
    end
  end
  def to_s
    name || "UnamedActor<#{self.class}>"
  end
end
class Player < Actor
end
class Enemy < Actor
  attr_accessor :ai
  def tick
    ai.tick
  end
end
class Zombie < Enemy
  defaults :hps => 15
           :energy => 5
           :renegate => 10
  def ai
    @ai ||= ZombieAI.new self
  end
  def abilities
    unless @abilities
      self.abilities = [Melee.new(:range => 1, :damage => 3), Movement.new(:speed => 1)]
    end
    @abilities
  end
end
