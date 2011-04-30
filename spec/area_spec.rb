require 'spec_helper'
describe Area do
  let (:area) { Area.new}
  it "has set of objects at coords without initialization" do
    area.at_coords[:foo].should respond_to(:each)
  end
  it "has accessor for blocked elements" do
    blocker = mock(:blocking? => true)
    area.at_coords[:foo].add blocker
    area.blocked?(:foo).should be_true
  end
end