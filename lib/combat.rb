module Combat
  def resolve attack, victim
    wound = attack.invoke(victim)
    wound.invoke(victim)
    spub :combat, victim, wound
  end
end
module Wound
  attr_accessor :severity
end