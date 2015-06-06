# require 'sinatra'
# require 'sinatra/json'
require 'httparty'
require 'pg'
require 'pry'

response = HTTParty.get('http://api.wunderground.com/api/fe47edab0cd8d58c/forecast/q/MA/Boston.json')
# binding.pry
puts response
