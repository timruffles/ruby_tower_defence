require 'spec_helper'
include AI
describe AStar do
  class Blocker
    def blocked?; true; end
  end
  let (:graph) { 
    XYGraphDecorator.new Area.new :at_coords => {
      [5,10] => [Blocker.new]
    }, :x_size => 10, :y_size => 10
  }
  before(:each) { @node = AStar.solve graph, [0,1], [10, 20] }
  it "finds a node by astar" do
    @node.should_not be_nil
  end
  it "finds a very simple path" do
    [[9,20],[10,19]].should include(@node)
  end
  it "route goes back to parent node" do
    @node.to_path.last.should == [0,1]
  end
  context "obstacle navigation" do
    let (:blocked_path) { 
      #  f | g   path should be  f | g
      #    |                     v | ^
      #                          > > ^
      XYGraphDecorator.new Area.new :at_coords => {
        [1,0] => [Blocker.new],
        [2,0] => [Blocker.new]
      }, :x_size => 3, :y_size => 3
    }
    before(:each) { @node = AStar.solve graph, [0,0], [2, 0] }
    it "ends at goal" do
      @node.state.should == [2,1] 
    end
    it "routes around path" do
      @node.to_path.should_not be_superset([[1,0],[2,0]])
    end
  end
end