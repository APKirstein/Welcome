require 'pg'
require 'pry'
require 'httparty'

def db_connection
  begin
    connection = PG.connect(dbname: 'todo')
    yield(connection)
  ensure
    connection.close
  end
end

def keys
  {
  "full" => :location,
  "observation_time" => :time_taken,
  "local_time_rfc822" => :local_time,
  "weather" => :weather,
  "temperature_string" => :temp,
  "wind_string" => :string
}
end

def sql_weather
  <<-SQL
  INSERT INTO weather_table(
    location,
    observation_time,
    local_time,
    weather,
    temperature,
    wind
  ) VALUES ($1, $2, $3, $4, $5, $6);
  SQL
end

def cache_data_weather
  response = HTTParty.get('http://api.wunderground.com/api/fe47edab0cd8d58c/conditions/q/MA/Boston.json')
  weather_data = []
  url_info = response["current_observation"]


  url_info.each do |key, info|
    if key == "display_location"
      weather_data << info["full"]
    elsif keys.has_key?(key)
      weather_data << info
    end
  end
  weather_data
end

def import_data
  db_connection do |conn|
    conn.exec_params(sql_weather, cache_data_weather)
  end
end

import_data
