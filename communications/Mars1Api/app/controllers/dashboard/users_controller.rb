
  class Dashboard::UsersController < ApplicationController
    layout "dashboard_layout"

    def index
      @users = User.all
    end

    def sand_storm
      @users = User.all
      @users.each do |x|
        x.update_attributes!(alert_title: "Storm Incoming", alert: "A Sand Storm has been spotted near your location. Return to base.", alert_sound: 3)
      end
      redirect_to dashboard_storm_simulator_path
    end

    def end_storm
      @users = User.all
      @users.each do |x|
        x.update_attributes!(alert_title: "All Clear", alert: "Sand Storm has passed, you are safe to continue your work.", alert_sound: 1)
      end
      redirect_to dashboard_storm_simulator_path
    end

    def edit
      @user = User.find(params[:id])
    end

    def edit_mission
      @user = User.find(params[:id])
    end

    def update_alert
      @user = User.find(params[:id])
      if @user.update(alert_params)
        redirect_to dashboard_users_index_path
      else
        @users = User.all
        render 'index'
      end
    end

    def update_mission
      @user = User.find(params[:id])
      if @user.update(mission_params)
        redirect_to dashboard_users_index_path
      else
        @users = User.all
        render 'index'
      end
    end

    private

    def alert_params
      params.require(:user).permit(:alert, :alert_title)
    end

    def mission_params
      params.require(:user).permit(:mission)
    end

  end
