require 'spec_helper'
include AI
describe AStar do
  class Blocker
    def blocked?; true; end
  end
  let (:area) { 
    Area.new.tap {|area|
      area.at_coords.merge! p(5,10) => [Blocker.new]
    }
  }
  before(:each) { @node = area.find_path p(0,1), p(10, 20) }
  it "finds a node by astar" do
    @node.should_not be_nil
  end
  it "finds a very simple path" do
    [p(9,20),p(10,19)].should include(@node.state)
  end
  it "route goes back to parent node" do
    @node.to_path.last.state.should == p(0,1)
  end
  context "obstacle navigation" do
    let (:blocked_path) { 
      #  f | g   path should be  f | g
      #    |                     v | ^
      #                          > > ^
      Area.new.tap {|area|
        area.at_coords.merge!({
          p(1,0) => [Blocker.new],
          p(2,0) => [Blocker.new]
        })
      }
    }
    before(:each) { @node = area.find_path p(0,0), p(2, 0) }
    it "ends at goal" do
      @node.state.should == p(2,1) 
    end
    it "routes around path" do
      @node.to_path.should_not be_superset([p(1,0),p(2,0)])
    end
  end
end