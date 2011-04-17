require_relative 'spec_helper'
describe World do
  let(:world) { World.new :x_size => 10 }
  it "has a map" do
    world.map.should_not be_nil
  end
  it "exposes map attributes" do
    world.x_size.should == 10
  end
end