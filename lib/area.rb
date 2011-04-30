module AreaInterface
  attr_accessor :x_size, :y_size, :at_coords
  defaults :at_coords => -> {Hash.new {Set.new}}
  def within_range(from,objects,range)
    objects.select do |positioned|
      distance(from,positioned) <= range
    end
  end
  def blocked? point
    at_coords[point].any(:blocking?)
  end
  def legal? point
    x,y = point.to_a
    not (y > top || x > right || y < bottom || x < left)
  end
  def right
    x_size
  end
  def left
    0
  end
  def top
    y_size
  end
  def bottom
    0
  end
end
class Area
  attr_accessor :world, :actors_to_spawn, :chunk_size, :spawn_rate_ticks, :last_spawn, :target_population
  defaults :last_spawn => 0,
           :graph => -> { XYGraph.new self }
  include HashInitializer
  include AreaInterface
  def tick
  end
end