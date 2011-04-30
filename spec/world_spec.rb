require_relative 'spec_helper'
describe World do
  let(:world) { World.new :x_size => 10 }
  it "has a area" do
    world.area.should_not be_nil
  end
  it "exposes area attributes" do
    world.x_size.should == 10
  end
  describe Point do
    it "is equal to equivalent points" do
      Point.new(0,4).should == Point.new(0,4)
    end
    it "is not equal to non-similar points" do
      Point.new(0,4).should_not == Point.new(1,4)
    end
  end
end