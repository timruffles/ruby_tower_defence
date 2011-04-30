require 'spec_helper'
describe Area do
  let (:area) { Area.new}
  it "has set of objects at coords without initialization" do
    area.at_coords[:foo].should respond_to(:each)
  end
end