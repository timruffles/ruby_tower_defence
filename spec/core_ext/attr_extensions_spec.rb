require_relative '../spec_helper'
describe "extensions" do
  it "allow a defaults to be set" do
    test = Class.new do
      attr_accessor :foo
      defaults :foo => 'bar'
    end
    ins = test.new
    ins.foo.should == 'bar'
  end
  it "allows a numeric to be defined and defaultsed in one" do
    test = Class.new do
      numeric_attr_accessor :foo
    end
    ins = test.new
    ins.foo.should == 0
  end
  it "allows a block to define default" do
    test = Class.new do
      defaults :foo => -> { 'bar' }
    end
    ins = test.new
    ins.foo.should == 'bar'
  end
  it "allows hash default setting" do
    test = Class.new do
      defaults :foo => -> { 'bar' },
               :fish => :fowl
    end
    ins = test.new
    ins.foo.should == 'bar'
    ins.fish.should == :fowl
  end
end