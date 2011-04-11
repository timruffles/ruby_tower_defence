Dir.glob(File.dirname(__FILE__) + '/core_ext/*.rb') do |f|
  require f
end