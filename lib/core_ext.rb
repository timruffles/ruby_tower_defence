module CoreExt; end
pre = CoreExt.constants
Dir.glob(File.join(File.dirname(__FILE__),'/core_ext/*.rb')) do |f|
  require f
end
(CoreExt.constants - pre).each do |constant|
  CoreExt.const_get(constant).mixin_targets.send :include, constant
  CoreExt.const_get(constant).extend_targets.send :extend, constant
end