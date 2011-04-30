module AStar
  def solve graph, queue, start, goal
    closed = {}
    while node = queue.next do
      return node if goal == node
      unless closed.has_key? node
        closed[node] = true
        queue.add graph.neighbours node
      end
    end
  end
  class << self
    include AStar
  end
end
