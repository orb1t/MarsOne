
module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      before_filter :authenticate_user!, except: [:index, :mc_update] # uses authenticate_user method
      skip_before_filter :verify_authenticity_token
      def index
        respond_with User.all.to_a
      end

      def update

        @user = User.find(params[:id]) # finds user from id passed through request
        if @user.update_attributes(user_params) # updates the params specified

          render json: {id: @user.id, email: @user.email, heart_rate: @user.heart_rate, distance: @user.distance,
                        avg_heart_rate: @user.avg_heart_rate, steps: @user.steps, lon: @user.lon, lat: @user.lat,
                        mission: @user.mission, alert: @user.alert, alert_title: @user.alert_title} # renders the json for all attributes
        else
           respond_with(status: :unprocessable_entity) # responds with an error
        end

      end

      def mc_update
        @user = User.find(params[:id]) # finds user from id passed through request
        if @user.update_attributes(mc_user_params) # updates the params specified

          render json: { mission: @user.mission, alert: @user.alert} # renders the json for all attributes
        else
           respond_with(status: :unprocessable_entity) # responds with an error
        end
      end

      def get_alert
        @email = request.headers["Email"] # finds email in header

        @user = User.find_by(email: @email) # finds user with that email
        respond_with @user.alert # displays json of the alert
      end

      private

      def user_params
        params.permit(:heart_rate, :distance, :avg_heart_rate, :steps, :lon, :lat, :mission, :alert, :alert_title, :oxygen_life, :oxygen_time) # specifies params permitted in json requests
      end

      def mc_user_params
        params.permit(:mission, :alert)
      end



    end
  end
end
