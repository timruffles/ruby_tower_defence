class AI::XYGraph
  include AI
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
      node.cost = 100000 if blocked?(node.state) # we need it in the neighbours returned in case it's the goal
      !legal?(node.state)
    end
  end
  def heuristic node, goal_node
    (node.state.x - goal_node.state.x).abs + (node.state.y - goal_node.state.y).abs
  end
  def find_path from, to
    AStar.solve(self, Node.new(from,0), Node.new(to,0)).to_path.map(&:state).reverse
  end
end