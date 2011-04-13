require_relative '../spec_helper'
require_relative '../../lib/core_ext/attr_extensions'
describe "extensions" do
  it "allow a default to be set" do
    test = Class.new do
      attr_accessor :foo
      default :foo, 'bar'
    end
    ins = test.new
    ins.foo.should == 'bar'
  end
  it "allows a numeric to be defined and defaulted in one" do
    test = Class.new do
      numeric_attr_accessor :foo
    end
    ins = test.new
    ins.foo.should == 0
  end
end