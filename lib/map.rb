module Map
  attr_accessor :x_size, :y_size
  def within_range(from,objects,range)
    objects.select do |positioned|
      distance(from,positioned) <= range
    end
  end
  def distance a, b
    Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)
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