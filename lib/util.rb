module HashInitializer
  def initialize opts = {}
    opts.each do |key,val|
      self.send "#{key}=", val
    end
  end
end
