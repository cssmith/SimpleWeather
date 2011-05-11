#!/usr/bin/env ruby

require 'open-uri'
require 'net/http'
require 'rubygems'
require 'libxml'
require 'xml'

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

class WeatherLibxml
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
    parser = XML::Parser.string(f_response)
    @forecast = parser.parse

    n_url = "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{URI.encode(param)}"
    n_response = Net::HTTP.get_response(URI.parse(n_url)).body
    parser = XML::Parser.string(n_response)
    @now = parser.parse

    @now.find('/current_observation').each do |curr|
      @location = curr.find_first('display_location/full').inner_xml
      @weather = curr.find_first('weather').inner_xml
      @temp_f = curr.find_first('temp_f').inner_xml
      @temp_c = curr.find_first('temp_c').inner_xml
      @observation_time = curr.find_first('observation_time').inner_xml
      @wind = curr.find_first('wind_string').inner_xml
      @source = curr.find_first('credit').inner_xml + ", " + curr.find_first('credit_URL').inner_xml
      @now_icon = curr.find_first('icons/icon_set/icon_url').inner_xml
    end

    @forecast_days = []

    @forecast.find('//forecast').each do |curr|
      curr.find('moon_phase').each do |moon|
        @sunset = moon.find_first('sunset/hour').inner_xml + ":" +
          moon.find_first('sunset/minute').inner_xml
        @sunrise = moon.find_first('sunrise/hour').inner_xml + ":" +
          moon.find_first('sunrise/minute').inner_xml
      end
      
      curr.find('txt_forecast/forecastday').each do |day|
        @forecast_days << Day.new(day.find_first('title').inner_xml,
                                  day.find_first('fcttext').inner_xml, 
                                  day.find_first('icons/icon_set').find_first('icon_url').inner_xml)
      end
    end
  end

  def current_string
    @temp_f + " degrees, " + @weather
  end

end


