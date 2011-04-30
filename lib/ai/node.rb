class AI::Node < Struct.new(:state, :cost, :parent)
  def to_path
    unless parent
      [self]
    else
      parent.to_path.concat [self]
    end
  end
  def == to
    to.state == state
  end
  alias :eql? :==
  def hash
    state.hash
  end
end