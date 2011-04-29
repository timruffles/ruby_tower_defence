class BodyPart
  class << self
    attr_accessor :area
    alias :old_to_s :to_s
    def to_s
      str = self.old_to_s.split('::').last
      str.slice(0..0) + str.slice(1..-1).gsub(/[A-Z]/,' \0')
    end
  end
end
class PairedBodyPart < BodyPart
end
class Joint < BodyPart
  class << self
    attr_accessor :item, :socket
    def joins connected, connected_to
      self.item = connected
      self.socket = connected_to
    end
  end
end
class Body
  class Head < BodyPart
    self.area = 0.1
  end
  class Torso < BodyPart
    self.area = 0.3
  end
  class Hands < PairedBodyPart
    self.area = 0.025
  end
  class Arms < PairedBodyPart
    self.area = 0.2
  end
  class UpperLeg < PairedBodyPart
    self.area = 0.1
  end
  class LowerLeg < PairedBodyPart
    self.area = 0.1
  end
  class Feet < PairedBodyPart
    self.area = 0.025
  end

  class Neck < Joint
    joins Head, Neck
    self.area = 0.025
  end
  class Shoulder < Joint
    joins Arms, Torso
    self.area = 0.025
  end
  class Wrists < Joint
    joins Hands, Arms
    self.area = 0.025
  end
  class Hips < Joint
    joins UpperLeg, Torso
    self.area = 0.025
  end
  class Knees < Joint
    joins LowerLeg, UpperLeg
    self.area = 0.025
  end
  class Ankle < Joint
    joins Feet, LowerLeg
    self.area = 0.025
  end
  class << self
    def parts
      constants.map {|con| const_get con }
    end
  end
end
def injury_word severity_percent, severities
  severity_index = 100 / severities.length
  word = severities[severity_percent / severity_index]
end
def injury_phrase actor, type, victim, body_part, severity_percent
  "#{actor} #{injury_word(severity_percent, Severities_by_type[type])} #{victim}'s #{body_part.to_s.downcase}"
end
class Array
  def sample
    at (rand * length).to_i
  end
end
Severities_by_type = {
  :shot => %w(grazed clipped shot nailed),
  :bash => %w(bruised broke pulverised),
  :stab => %w(pricked stabbed impaled),
  :shrapnel => ['scratched','clipped','blew off'],
  :bite => ['nibbled','bit','tore a chunk from', 'ate'],
  :slash => %w(cut gashed dismembered)
}

# test
zombies = ['ugly zombie','smelly zombie']
players = ['Joe','Fred']
types = Severities_by_type.keys

(1..10).to_a.each do |n|
  p injury_phrase players.sample, Severities_by_type.keys.sample, zombies.sample,  Body.parts.sample, (rand * 100).to_i
end
