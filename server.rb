require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'date'
require 'pry'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "todo")
    yield(connection)
  ensure
    connection.close
  end
end

get '/home' do
  tasks = db_connection { |conn| conn.exec("SELECT name FROM task") }
  forecasts = Array.new
  forecasts = db_connection { |conn| conn.exec("SELECT * FROM forecast") }
  weather = db_connection { |conn| conn.exec("SELECT
    location,
    observation_time,
    local_time,
    weather,
    temperature,
    wind
    FROM weather_table
    ORDER BY id DESC
    LIMIT 1
") }
  date_function = Date.today

  erb :index, locals: { date: date_function, tasks: tasks, weather: weather, forecasts: forecasts }
end

post '/home' do
  task = params["task_name"]

  if task == ""
    redirect '/home'
  else
    db_connection do |conn|
      conn.exec_params("INSERT INTO task (name) VALUES ($1)", [task])
      redirect "/home"
    end
  end
end

post '/home/delete_name' do
  delete_name = params["delete_name"].to_s

  db_connection do |conn|
    conn.exec_params("DELETE FROM task WHERE name = ($1)", [delete_name])
  end
  redirect "/home"
end
