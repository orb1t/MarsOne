module Api
  module V1
    class SessionsController < ApplicationController
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        @email = request.headers["Email"]
        @password = request.headers["Password"]

        if User.find_by(email: @email) # gets user from email sent in header
          @user = User.find_by(email: @email)
          if @user && @user.valid_password?(@password) # uses deivse method to check if password is valid
            @user.update_attributes(authentication_token: SecureRandom.base64(20)) # generates a auth token useing built in rails random string generator
            render json: { status: 200, id: @user.id,email: @user.email, authentication_token: @user.authentication_token }
          else
            render json: {}, status: :unauthorized # if password invalid, returns 401, unauthorized
          end
          else
          render json: {}, status: :unauthorized # if email not found, returns 401, unauthorized
        end
      end

      def destroy
        @user = User.find(params[:id]) # locates user from id param
        @user.authentication_token = nil #sets the auth token to nil
        render json: {status: 200} # returns a 200 success
      end
    end
  end
end
