require_relative '../spec_helper'
describe "extensions" do
  it "allow a attr_reader_with_default to be set" do
    test = Class.new do
      attr_accessor :foo
      attr_reader_with_default :foo, 'bar'
    end
    ins = test.new
    ins.foo.should == 'bar'
  end
  it "allows a numeric to be defined and attr_reader_with_defaulted in one" do
    test = Class.new do
      numeric_attr_accessor :foo
    end
    ins = test.new
    ins.foo.should == 0
  end
end