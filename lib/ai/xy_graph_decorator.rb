class AI::XYGraphDecorator
  attr_accessor :area
  delegate AreaInterface, :to => :area
  def initialize area
    self.area = area
  end
  def neighbours point
    x, y = point.to_a
    n = -> x, y, parent { Node.new p(x,y), parent.cost + 1, parent }
    [n.(x, y + 1),  n.(x + 1, y),  n.(x, y - 1),  n.(x - 1, y)].reject do |node| 
      blocked?(node) || !legal?(node.state)
    end
  end
  def heuristic node, goal_node
    Math.abs(node.x - goal_node.x) + Math.abs(node.y - goal_node.y)
  end
end