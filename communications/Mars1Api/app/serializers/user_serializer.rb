class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :heart_rate, :avg_heart_rate, :steps, :lon, :lat, :mission, :alert, :alert_title, :alert_sound

end
