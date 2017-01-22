class MarsReport
  include Mongoid::Document

  field :terrestrial_date, type: String
  field :sol, type: Integer
  field :ls, type: Float
  field :min_temp, type: Float
  field :min_temp_fahrenheit, type: Float
  field :max_temp, type: Float
  field :max_temp_fahrenheit, type: Float
  field :pressure, type: Float
  field :pressure_string, type: String
  #field :abs_humidity, type: String
  #field :wind_speed, type: Float
  field :wind_direction, type: String
  field :atmo_opacity, type: String
  field :season, type: String
  field :sunrise, type: String
  field :sunset, type: String

  validates :terrestrial_date, uniqueness: true 

end
