module Api
  module V1
    class SessionsController < ApplicationController
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        @email = request.headers["Email"]
        @password = request.headers["Password"]

        if User.find_by(email: @email)
          @user = User.find_by(email: @email)
          if @user && @user.valid_password?(@password)
            @user.update_attributes(authentication_token: SecureRandom.base64(20))
            render json: { status: 200, email: @user.email, authentication_token: @user.authentication_token }
          else
            render json: {}, status: :unauthorized
          end
          else
          render json: {}, status: :unauthorized
        end
      end

      def destroy
        @user = User.find(params[:id])
        @user.authentication_token = nil
        render json: {status: 200}
      end
    end
  end
end
