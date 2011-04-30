class AI::XYGraph
  attr_accessor :area
  delegate AreaInterface, :to => :area
  def initialize area
    self.area = area
  end
  def neighbours node
    point = node.state
    x, y = point.to_a
    n = -> x, y { Node.new p(x,y), node.cost + 1, node }
    [n.(x, y + 1),  n.(x + 1, y),  n.(x, y - 1),  n.(x - 1, y)].reject do |node| 
      blocked?(node.state) || !legal?(node.state)
    end
  end
  def heuristic node, goal_node
    Math.abs(node.state.x - goal_node.state.x) + Math.abs(node.state.y - goal_node.state.y)
  end
  def find_path from, to
    AStar.solve self, Node.new(from,0), Node.new(to,0)
  end
end