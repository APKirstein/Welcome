-- weather_table schema

DROP TABLE weather_table CASCADE;

CREATE TABLE weather_table(
  id SERIAL PRIMARY KEY,
  location VARCHAR(255),
  observation_time VARCHAR(255),
  local_time VARCHAR(255),
  weather VARCHAR(255),
  temperature VARCHAR(255),
  wind VARCHAR(255)
);
