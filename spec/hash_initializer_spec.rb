describe "hash init" do
  class Meh
    include HashInitializer
    defaults :foo => :bar
    attr_accessor :foo
  end
  a = Meh.new
  puts a.foo
  a = Meh.new :foo => :baz
  puts a.foo
end