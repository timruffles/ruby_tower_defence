# methods that deal with representing game objects in serialized form for the API
class World
  def to_h
    {
      :actors => actors.inject({}) {|h,act| h[act.id] = act.to_h; h },
      :area => area.to_h,
      :at_coords => at_coords.inject({}) do |h,locs|
        point, here = locs
        h[point] = here.map(&:id)
        h
      end
    }
  end
  def messages_for_client
    tick_messages.to_json
  end
end
class Actor
  # used when entire actor data is important
  def to_h
    attribute_hash(:hps, :dead, :point, :id, :name).merge(:type => self.class)
  end
  # used implicitly, to give a reference to the actors hash
  def to_json *a
    id.to_json(*a)
  end
end
class Area
  def to_h
    {
      :x_size => x_size,
      :y_size => y_size
    }
  end
  def to_json *a
    to_h.to_json *a
  end
end
