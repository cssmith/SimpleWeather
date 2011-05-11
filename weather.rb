#!/usr/bin/env ruby

require 'open-uri'
require 'net/http'
require 'rexml/document'

class Day
  attr_accessor :title
  attr_accessor :text
  attr_accessor :icon

  def initialize(title, text, icon)
    @title = title ? title : "";
    @text = text ? text : "";
    @icon = icon ? icon : "";
  end
end

class Weather
  attr_reader :location
  attr_reader :weather
  attr_reader :temp_c
  attr_reader :temp_f
  attr_reader :observation_time
  attr_reader :wind
  attr_reader :sunset
  attr_reader :sunrise
  attr_reader :forecast_days
  attr_reader :source
  attr_reader :now_icon

  attr_reader :forecast
  attr_reader :now
  
  def initialize(param)

    param = "Philadelphia, PA" if (!param || param == "")
    f_url = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{URI.encode(param)}"
    f_response = Net::HTTP.get_response(URI.parse(f_url)).body                              
    @forecast = REXML::Document.new(f_response)

    n_url = "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{URI.encode(param)}"
    n_response = Net::HTTP.get_response(URI.parse(n_url)).body
    @now = REXML::Document.new(n_response)

    @now.elements.each('current_observation') do |curr|
      @location = curr.elements['display_location'].elements['full'].text
      @weather = curr.elements['weather'].text
      @temp_f = curr.elements['temp_f'].text
      @temp_c = curr.elements['temp_c'].text
      @observation_time = curr.elements['observation_time'].text
      @wind = curr.elements['wind_string'].text
      @source = curr.elements['credit'].text + ", " + curr.elements['credit_URL'].text
      @now_icon = curr.elements['icons'].elements['icon_set'].elements['icon_url'].text
    end
    
    @forecast_days = []

    @forecast.elements.each('forecast') do |curr|
      curr.elements.each('moon_phase') do |moon|
        @sunset = moon.elements['sunset'].elements['hour'].text + ":" +
          moon.elements['sunset'].elements['minute'].text
        @sunrise = moon.elements['sunrise'].elements['hour'].text + ":" +
          moon.elements['sunrise'].elements['minute'].text
      end
      
      curr.elements.each('txt_forecast/forecastday') do |day|
        @forecast_days << Day.new(day.elements['title'].text,
                                  day.elements['fcttext'].text, 
                                  day.elements['icons'].elements['icon_set'].elements['icon_url'].text)
      end
    end
  end

  def current_string
    @temp_f + " degrees, " + @weather
  end

  def image_html
    puts '<html><body>'
    @forecast.elements.each('forecast/txt_forecast/forecastday') do |day|
      puts '<p>'
      day.elements.each('icons/icon_set/icon_url') do |icon|
        puts '<img src="' + icon.text + '">'
      end
      puts '</p>'
    end

    puts '</body></html>'
  end
end


