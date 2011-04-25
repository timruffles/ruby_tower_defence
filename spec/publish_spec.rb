require_relative 'spec_helper'
describe "publish" do
  let (:test) {
    Class.new do
      include Publish::Publisher
      attr_writer_evented :foo
      attr_reader :foo
    end
  }
  let (:instance) { test.new }
  it "defines a working writer" do
    instance.stubs(:pub)
    instance.foo = 'bar'
    instance.foo.should == 'bar'
  end
  it "publishes events on write" do
    instance.expects(:pub)
    instance.foo = 'bar'
  end
end