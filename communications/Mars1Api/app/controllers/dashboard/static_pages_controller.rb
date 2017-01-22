module Dashboard
  class StaticPagesController < ApplicationController
    layout "dashboard_layout"
    def home
      @mars_report = MarsReport.last
      @astro1 = User.find_by(email: "john@nasa.gov")
      @astro2 = User.find_by(email: "jan@nasa.gov")
      @astro3 = User.find_by(email: "zach@nasa.gov")
    end
  end
end
