module HashInitializer
  def initialize opts = {}
    pp "#{self} hinit #{opts}"
    opts.each do |key,val|
      self.send "#{key}=",val
    end
  end
end
