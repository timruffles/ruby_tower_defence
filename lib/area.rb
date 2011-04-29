module AreaInterface
  attr_accessor :x_size, :y_size
  def within_range(from,objects,range)
    objects.select do |positioned|
      distance(from,positioned) <= range
    end
  end
  def types_in_range positioned, types, range
    within_range(positioned,population(*types),range) - [positioned]
  end
  def actors_by_coords
    actors.inject({}) do |coords,actor|
      coords[[actor.x,actor.y]] = actor
      coords
    end
  end
  def blocked? x,y
    actors_by_coords[[x,y]].any(:blocking?)
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
  defaults :last_spawn => 0
  include HashInitializer
  include AreaInterface
  def tick
  end
end