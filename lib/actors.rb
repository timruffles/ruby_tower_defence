module Positioned
  numeric_attr_accessor :x, :y
end
class Actor
  attr_accessor :name, :abilities, :dead
  numeric_attr_accessor :hps, :energy, :regenerate, :recharge
  attr_reader_with_default :dead, false
  include Publish::Publisher
  evented_accessor :energy, :hps, :dead
  include Positioned
  include HashInitializer
  include Worldly
  def tick_callbacks
    @tick_callbacks ||= methods.select {|method| /_on_tick$/ =~ method}
  end
  def tick
    tick_callbacks.each {|method| self.send method } unless dead
  end
  def regenerate_and_run_activity_on_tick
    self.hps += regenerate
    self.energy += recharge
    self.current_ability.tick
  end
  def hps_with_death= val
    dead = true if val <= 0
    hps_without_death = val
  end
  alias_method_chain :hps=, 'death'
  def current_ability
    @current_ability ||= abilities.first
  end
  def abilities= abilities
    @abilities = abilities
    @abilities.each do |ability|
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
end
class Zombie < Enemy
  attr_reader_with_default :hps => 15,
                           :energy => 5,
                           :renegate => 10,
                           :abilities => -> { [Melee.new(:range => 1, :damage => 3), Movement.new(:speed => 1)] }
  def current_ability
    abilities.random
  end
end
