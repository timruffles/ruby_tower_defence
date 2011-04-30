require 'spec_helper'
shared_examples_for "a graph" do
  it "provides nodes around a vertex" do
    graph.neighbours(example_node).should respond_to :each_pair
  end
  it "provides all nodes" do
    graph.nodes.should respond_to :each_pair
  end
end
include AI
describe Node do
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
  it "is equal to nodes with identical states" do
    Node.new(:foo).should == Node.new(:foo)
  end
  it "is not equal to nodes with different states" do
    Node.new(:foo).should_not == Node.new(:bar)
  end
end

