require 'weather_libxml'

print "Enter location: "
loc = gets.chomp

myweather = WeatherLibxml.new(loc)
puts "<p>"
puts "The current conditions in " +  myweather.location + " are: <br>"
puts "<img src=" + myweather.now_icon  + " /><br>"
puts "<b>" +  myweather.current_string + "</b><br>"
puts "<b>Wind: </b>" +  myweather.wind + "<br>"
puts "<b>Sunrise: </b> " +  myweather.sunrise + "<br>"
puts "<b>Sunset: </b> " +  myweather.sunset + "<br>"
puts "</p>"

puts "<p>"
puts "<table border=1>"
puts "<tr>"
myweather.forecast_days.each do |day|
  puts "<td><b>" +  day.title + "</b></td>"
end
puts "</tr>"

puts "<tr>"
myweather.forecast_days.each do |day|
  puts "<td><img src=\"" +  day.icon + "\" /><br></td>"
end
puts "</tr>"

puts "<tr>"
myweather.forecast_days.each do |day|
  puts "<td><b>" +  day.text + "</b></td>"
end
puts "</tr>"
puts "</table>"
puts "</p>"

puts "<p>"
puts "<i>" +  myweather.observation_time + "</i><br>"
puts "<i>Weather data courtesy of " +  myweather.source + "</i>"
puts "</p>"