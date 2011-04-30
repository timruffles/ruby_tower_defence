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
require_relative '../../lib/ai/node'
describe Node do
  it "can return a one-dim list representing path to intitial node" do
    node = Node.new(:a,1,Node.new(:b,1,Node.new(:c,1)))
    node.to_path.map(&:state).should == [:c, :b, :a]
  end
end

