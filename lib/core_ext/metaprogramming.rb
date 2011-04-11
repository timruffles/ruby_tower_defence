class Module
  def macros macros
    class_eval do
      define_method :included do |into|
        macros.each do |macro|
          into.extend(macro)
        end
      end
    end
  end
end