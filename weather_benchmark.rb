require 'weather'
require 'weather_libxml'
require 'benchmark'

print "Enter location: "
loc = gets.chomp

Benchmark.bm(7) do |x|
  x.report("rexml:") { weather = Weather.new(loc) }
  x.report("libxml:") { weather_libxml = WeatherLibxml.new(loc) }
end
