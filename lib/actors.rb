module Positioned
  numeric_attr_accessor :x, :y
end
class Actor
  attr_accessor :name, :abilities
  numeric_attr_accessor :hps, :energy, :regenerate, :recharge
  include Publish::Publisher
  evented_accessor :hps, :energy
  include Positioned
  include HashInitializer
  include Worldly
  def tick_callbacks
    @tick_callbacks ||= methods.select {|method| /_on_tick$/ =~ method}
  end
  def tick
    tick_callbacks.each {|method| self.send method }
  end
  def regenerate_and_run_activity_on_tick
    self.hps += regenerate
    self.energy += recharge
    self.current_ability.tick
  end
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
    name
  end
end
class Player < Actor
end
class Enemy < Actor
end
class Zombie < Enemy
  default (:abilities) { [Melee.new(:range => 1, :damage => 3), Movement.new(:speed => 1)] }
  def current_ability
    abilities.random
  end
end
