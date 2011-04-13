require_relative 'spec_helper'
describe "publish" do
  it "defines a working writer" do
    test = Class.new do
      include Publish::Publisher
      attr_writer_evented :foo
      attr_reader :foo
    end
    ins = test.new
    ins.stubs(:pub)
    ins.foo = 'bar'
    ins.foo.should == 'bar'
  end
end