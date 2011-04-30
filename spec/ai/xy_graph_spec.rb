desribe AreaToXYGraph do
  let (:graph) { XYGraph.new Area.new }
  
  it_should_behave_like "a graph"
end