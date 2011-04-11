class World
  include HashInitializer
  attr_accessor :tick, :actors
  attr_reader :publish_context
  default :publish_context { PublishContext.new }
  default :map { Map.new }
  delegates :pub, :spub, :events, :to => :publish_context
  delegates Map, :to => :map
  def run
    until round_over? do
      actors.each(&:tick)
      draw
      sleep 1
    end
    tick += 1
  end
  def players
    actors.select {|a| a.is_a?(Player) }
  end
  def enemies
    actors.select {|a| a.is_a?(Enemy) }
  end
  def tick
    @tick ||= 0
  end
  def round_over?
    tick > 1000 || players.empty?
  end
  def actors_by_coords
    actors.inject({}) do |coords,actor|
      coords[[actor.x,actor.y]] = actor
      coords
    end
  end
  def draw
    actors_at_coords = actors_by_coords
    (0..y_size).each do |row_i|
      row = []
      (0..x_size).each do |col_i|
        at_coord = actors_at_coords[[col_i,row_i]]
        output = case at_coord
                   when nil
                     ' '
                   when Enemy
                     'E'
                   when Player
                     'P'
                 end
        row << output
      end
      puts "|#{row.join(' ')}|\n"
    end
  end
end
# gives instance access to world, via top level WorldInstance const, or a personal world
module Worldly
  attr_reader :world
  default :world { WorldInstance || World.new }
  include Publish::Publisher
  delegate :pub, :spub, :to => :world
end