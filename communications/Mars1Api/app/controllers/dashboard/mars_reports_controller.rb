module Dashboard
  class MarsReportsController < ApplicationController
    layout "dashboard_layout"

    def index
      @reports = MarsReport.all
    end
  end
end
