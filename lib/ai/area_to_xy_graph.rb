def p x,y; Point.new x,y; end
module AreaToXYGraph
  def create_graph
    coords.inject({}) do |graph, point|
      graph[point] = movement_costs_removing_blocked(neighbours,Point.new(point))
      graph
    end
  end
  # which nodes can be accessed from here?
  def neighbours point
    x, y = point.to_a
    neighbours = []
    neighbours << p(x, y + 1) unless y == top
    neighbours << p(x + 1, y) unless x == right
    neighbours << p(x, y - 1) unless y == bottom
    neighbours << p(x - 1, y) unless x == left
    neighbours
  end
  def movement_costs_removing_blocked nodes, current_node
    Hash[nodes.reject {|node| blocked? node}.map do |node|
      [node,cost_from(node,current_node)]
    end]
  end
  def cost_to node, to_node
    1
  end
  def heuristic node, to_node
    Math.abs(node.x - to_node.x) + Math.abs(node.y + to_node.y)
  end
end