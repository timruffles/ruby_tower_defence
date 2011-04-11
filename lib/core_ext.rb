module CoreExt; end
pre = CoreExt.constants
Dir.glob('core_ext/*.rb') do |f|
  require f
end
(CoreExt.constants - pre).each do |constant|
  CoreExt.const_get(constant).mixin_to.send :include, constant
end