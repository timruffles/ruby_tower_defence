require 'spec_helper'
describe SortedQueue do
  let(:q) { SortedQueue.new {|a,b| a <=> b}}
  it "adds a list of items" do
    q.add [:foo]
    q.next.should == :foo
  end
end