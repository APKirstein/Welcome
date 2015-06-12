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


forecast = Array.new
forecast << db_connection { |conn| conn.exec("SELECT * FROM forecast") }
binding.pry
puts forecast
