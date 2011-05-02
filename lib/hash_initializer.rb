module HashInitializer
  def initialize opts = {}
    super
    opts.each do |key,val|
      self.send "#{key}=",val
    end
  end
end
