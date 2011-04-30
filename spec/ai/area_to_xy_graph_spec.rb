desribe AreaToXYGraph do
  let (:graph) { AreaToXYGraph.new Area.new }
  let (:graph_type) { AreaToXYGraph.new Area.new }
  
  it_should_behave_like "a graph"
end