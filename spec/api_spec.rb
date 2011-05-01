require 'spec_helper'
describe 'Server -> Client API' do
  context "start of match, send setup to client" do
    before :all do
      world = Factory(:world, :actors => [
        @zombie_one = Factory(:zombie, :x => 1),
        Factory(:zombie)
      ], :area => Area.new)
      world.register_actor_positions
      @hash = world.to_hash
    end
    it "passes world data" do
      @hash[:actors].length.should == 2
    end
    it "has coordinate info linked to actors" do
      @hash[:at_coords][p(1,0)].should include(@zombie_one.id)
    end
    it "can be converted to json" do
      -> { @hash.to_json }.should_not raise_error
    end
  end
end