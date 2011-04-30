require 'spec_helper'
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
describe 'node' do
  include AI
  it "can return a one-dim list representing path to intitial node" do
    node = Node.new(:a,1,Node.new(:b,1,Node.new(:c,1)))
    node.to_path.map(&:state).should == [:c, :b, :a]
  end
  [:state, :cost, :parent].each do |method|
    it "has accessors for #{method}" do
      node = Node.new(:foo, :foo, :foo)
      node.send(method).should == :foo
      node.send("#{method}=",:bar)
      node.send(method).should == :bar
    end
  end
end

