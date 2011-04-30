require 'spec_helper'
include AI
describe AStar do
  let (:blocker) { stub(:blocking? => true)}
  let (:area) { 
    Area.new(:x_size => 30, :y_size => 30).tap {|area|
      area.at_coords.merge! p(5,10) => [blocker]
    }
  }
  before(:each) { @node = area.find_path p(0,1), p(10, 20) }
  it "finds a node by astar" do
    @node.should_not be_nil
  end
  it "route goes back to parent node" do
    @node.to_path.first.state.should == p(0,1)
  end
  context "obstacle navigation" do
    let (:blocked_path) { 
      #  f | g   path should be  f | g
      #    |                     v | ^
      #                          > > ^
      Area.new(:x_size => 30, :y_size => 30).tap {|area|
        area.at_coords.merge!({
          p(1,0) => [blocker],
          p(1,1) => [blocker]
        })
      }
    }
    before(:each) { @node = blocked_path.find_path p(0,0), p(2, 0) }
    it "ends at goal" do
      @node.state.should == p(2,0) 
    end
    it "routes around path" do
      [Node.new(p(1,0)), Node.new(p(1,1))].each do |blocked|
        @node.to_path.map(&:state).map(&:to_s).should_not include(blocked.state.to_s)
      end
    end
  end
end