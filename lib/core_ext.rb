Dir.glob(File.dirname(__FILE__) + '/core_ext/*.rb') do |f|
  require f
end
class Array
  def random
    self.send :[], rand * (length)
  end
end
class Object
  def in? enum
    enum.include? self
  end
end