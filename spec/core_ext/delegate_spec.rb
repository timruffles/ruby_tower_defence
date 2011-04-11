require_relative '../spec_helper'
Lib.req 'core_ext/delegate'
describe "Delegation" do
  class Inside
    def a; 'a'; end
    def b; 'b'; end
  end
  describe "arrays of methods" do
    Test = Class.new do
      extend CoreExt::Delegate
      def inside
        @inside ||= Inside.new
      end
      delegate :a, :b, :to => :inside
    end
    let(:instance) { Test.new }

    it "delegates an array of methods" do
      instance.a.should == 'a'
      instance.b.should == 'b'
    end
  end
  describe "classes" do
    TestClassDelegate = Class.new do
      extend CoreExt::Delegate
      def inside
        @inside ||= Inside.new
      end
    end
    let(:instance) { TestClassDelegate.new }
    it "only delegates new instance methods" do
      pre = TestClassDelegate.instance_methods.length
      TestClassDelegate.send :delegate, Inside, :to => :inside
      TestClassDelegate.instance_methods.length.should == pre + 2
    end
    it "delegates an array of methods" do
      instance.a.should == 'a'
      instance.b.should == 'b'
    end
  end
end