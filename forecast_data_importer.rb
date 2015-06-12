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

def forecast_keys
  {
  "fcttext" => :forecast,
  "title" => :title,
  "icon" => :icon,
  "icon_url" => :url
  }
end

def sql_forecast
  <<-SQL
  INSERT INTO forecast(
    day,
    forecast,
    icon_url,
    icon_type
  ) VALUES ($3, $4, $2, $1);
  SQL
end

def prepare_table
  <<-SQL
  TRUNCATE forecast;
  SQL
end

def cache_data_forecast
  response = HTTParty.get('http://api.wunderground.com/api/fe47edab0cd8d58c/forecast/q/MA/Boston.json')
  forecast_data = []
  forecast = response["forecast"]
  temp = nil

  forecast.each do |key, info|
    if key == "txt_forecast"
      info["forecastday"].each do |title|
        temp = Array.new
        title.each do |final, time|
          if forecast_keys.has_key?(final)
            temp << time
          end
        end
        forecast_data << temp
      end
    end
  end
  forecast_data
end

def forecast_import
  db_connection do |conn|
    conn.exec(prepare_table)
    cache_data_forecast.each do |weather|
      conn.exec_params(sql_forecast, weather)
    end
  end
end

forecast_import
