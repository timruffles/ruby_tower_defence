# collects interesting stats about the game
class Stats
  include Publish::Publisher
  defaults :stats => -> { Hash.new {|h,k| h[k] = 0 } }
  delegate :publish_context, :to => :world
  def initialize world
    self.world = world
    sub :ranged, :count_shots, Player
    sub :change, :count_zombies_killed, Zombie, [:dead]
    sub :change, :player_hps_lost, Player, [:hps]
    sub :before_end, :send_stats
  end
  protected
  attr_accessor :world
  def player_hps_lost *_, now, b4
    diff = now - b4
    stats[:player_hps_lost] -= diff if diff < 0
  end
  def count_shots *_
    stats[:shots] += 1
  end
  def count_zombies_killed *_
    stats[:zombies_killed] += 1
  end
  def send_stats *_
    spub :stats, stats
  end
end