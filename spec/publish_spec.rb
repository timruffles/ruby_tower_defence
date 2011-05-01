require_relative 'spec_helper'
describe "pubsub" do
  let (:test) {
    Class.new do
      include Publish::Publisher
      attr_writer_evented :foo
      attr_reader :foo
    end
  }
  let (:instance) { test.new }
  describe "attr_accessor_evented" do
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
  describe "sub" do
    it "is informed of any event having a matching event" do
    end
    it "is informed of any event with a matching subject class and event" do
    end
    it "is informed of any event with a matching subject and event" do
    end
  end
end
