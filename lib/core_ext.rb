Dir.glob('core_ext/*.rb') {|f| require f }
class Array
  def random
    self.send :[], rand * (length)
  end
end