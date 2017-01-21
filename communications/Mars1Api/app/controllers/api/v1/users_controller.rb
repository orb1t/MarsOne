
module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      before_filter :authenticate_user!, except: :index
      def index
        respond_with User.all.to_a
      end

      def update

        @user = current_user
          if @user.update_attributes(user_params)
            respond_with @user
          else
            respond_with(status: :unprocessable_entity)
          end
      end

      def get_alert
        @email = request.headers["Email"]

        @user = User.find_by(email: @email)
        respond_with @user.alert
      end

      private

      def user_params
        params.permit(:heart_rate, :distance, :avg_hear_rate, :steps, :lon, :lad, :mission, :alert)
      end



    end
  end
end
