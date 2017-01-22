class User
  # write validation to ensure email is @nasa.gov only
  # acts_as_token_authenticatable
  include Mongoid::Document
  # store_in database: ->{ Thread.current[:database] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :authentication_token, type: String
  field :heart_rate, type: Integer
  field :steps, type: Integer
  field :distance, type: Float
  field :lon, type: Float
  field :lat, type: Float
  field :avg_heart_rate, type: Integer
  field :mission, type: String
  field :alert, type: String
  field :oxygen_time, type: Integer
  field :oxygen_life, type: Float
  field :alert_title, type: String 
  #index({ starred: 1 })
  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
end
