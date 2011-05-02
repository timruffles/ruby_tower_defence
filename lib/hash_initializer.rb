module HashInitializer
  def initialize opts = {}
    run_callbacks :initialize do
      opts.each do |key,val|
        self.send "#{key}=",val
      end
    end
  end
end
