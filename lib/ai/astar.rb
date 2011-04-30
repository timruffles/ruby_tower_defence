module AI::AStar
  # deliberately broken exactly how it's done in AIMA - demonstrates the
  # generic components that make up the astar alogrithm
  # http://aima.cs.berkeley.edu/python/search.html
  def solve graph, start, goal
    # astar specific bit of algo - cost to node + heuristic cost to goal
    fitness = -> node { node.cost + graph.heuristic(node,goal) }
    best_first_graph_search graph, fitness, start, goal
  end
  def best_first_graph_search graph, fitness, start, goal
    queue = SortedQueue.new {|a,b| fitness.(a) <=> fitness.(b) }
    graph_search graph, queue, start, goal
  end
  def graph_search graph, queue, start, goal
     closed = {}
     queue.add start
     while node = queue.next do
       return node if goal == node
       unless closed.has_key? node
         closed[node] = true
         queue.add graph.neighbours node
       end
     end
   end
  class << self
    include AI::AStar
  end
end
