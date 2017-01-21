require 'net/http'
require 'json'
module Api
  module V1
    class MarsReportsController < ApplicationController
      respond_to :json

      def index
        respond_with MarsReports.all.to_a
      end

      def create
         url = URI.parse('http://marsweather.ingenology.com/v1/latest/')
         req = Net::HTTP::Get.new(url.to_s)
         res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
         @report = res.body
         @paresed_report = JSON.parse(@report)
         respond_with @report

       end
     end
   end
 end
