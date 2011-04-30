shared_examples_for "a graph" do
  it "initialises from a hash of vertexs and edges" do
    distances = {:b => 2,:c => 3,:d => 4}
    instance = graph_type.new({:a => distances})
    instance.get(:a).should == distances
  end
  it "provides nodes around a vertex" do
    graph.accessible(example_node).should respond_to :each_pair
  end
  it "provides all nodes" do
    graph.nodes.should respond_to :each_pair
  end
end
