class Actor
  include HashInitializer
  include Positioned
  include Worldly
  include Publish::Publisher

  attr_accessor :name
  attr_reader :dead
  numeric_attr_accessor :hps
  attr_writer_evented :hps, :dead
  defaults :dead, false
  alias :dead? :dead
  attr_accessor :ai
  def tick_callbacks
    @tick_callbacks ||= methods.select {|method| /_on_tick$/ =~ method}
  end
  def tick
    tick_callbacks.each {|method| self.send method } unless dead?
  end
  def regenerate_and_run_activity_on_tick
    self.current_ability.tick
  end
  def hand_off_to_ai_on_tick
    ai.tick
  end
  def hps_with_death= val
    self.dead = true if val <= 0
    puts "#{self} hps set to: dead #{dead?}"
    self.hps_without_death = val
  end
  alias_method_chain :hps=, 'death'
  def current_ability
    @current_ability ||= Wait.new
  end
  def abilities
    []
  end
  def abilities= abilities
    @abilities = abilities.map do |ability|
      ability.actor = self
      ability.class.to_s.underscore.to_sym
    end.zip(abilities).instance_eval { Hash[self] }
  end
  def invoke ability, on
    abilities[ability].invoke on
  end
  def to_s
    name || "UnamedActor<#{self.class}>"
  end
end
class Player < Actor
  defaults :hps => 15
  def ai
    @ai ||= PlayerAI.new self
  end
  def abilities
    self.abilities = [Ranged.new(:range => 3, :damage => 3)] unless @abilities
    @abilities
  end
end
class Enemy < Actor
end
class Zombie < Enemy
  defaults :hps => 9
  def ai
    @ai ||= ZombieAI.new self
  end
  def abilities
    self.abilities = [Melee.new(:range => 1, :damage => 3), Movement.new(:speed => 1)] unless @abilities
    @abilities
  end
end
