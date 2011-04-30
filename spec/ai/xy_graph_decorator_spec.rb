desribe AreaToXYGraph do
  let (:graph) { XYGraphDecorator.new Area.new }
  let (:graph_type) { XYGraphDecorator.new Area.new }
  
  it_should_behave_like "a graph"
end