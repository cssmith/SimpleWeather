require 'weather_libxml'
require 'benchmark'

#print "Enter location: "
#loc = gets.chomp
loc = "19130"
puts Benchmark.measure {
  mw = Weather.new(loc)
  puts "Current conditions in " + mw.location + " are:"
  puts mw.current_string
  puts "Wind: " + mw.wind
  puts "Sunrise: " + mw.sunrise
  puts "Sunset: " + mw.sunset
  puts mw.observation_time

  puts ""
  puts "Three day forecast: "
  mw.forecast_days.each do |day|
    puts day.title + ": "
    puts "\t" + day.text 
  end

  puts ""
  puts "Weather data courtesy of " + mw.source
}
