class MarsReportSerializer < ActiveModel::Serializer
  attributes :id, :terrestrial_date, :sol, :ls, :min_temp, :min_temp_fahrenheit, :max_temp, :max_temp_fahrenheit, :pressure, :pressure_string,
              :wind_direction, :season, :sunrise, :sunset

end
