require 'net/http'
require 'json'
module Api
  module V1
    class MarsReportsController < ApplicationController
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def index
        respond_with MarsReport.all.to_a # displays all mars_reports objects in json
      end

      def show_latest
        @mars_report = MarsReport.last
        respond_with @mars_report
      end

      def import_nasa_data
         url = URI.parse('http://marsweather.ingenology.com/v1/archive/?terrestrial_date_start=2016-1-20&terrestrial_date_end=2016-12-30')
         req = Net::HTTP::Get.new(url.to_s) # sends get request to url containing the api for data from Nasa rover on MARS!! That's pretty cool yo
         res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
         @report = res.body
         parsed_report = JSON.parse(@report) # parses through the json from the get request
         while parsed_report["next"].present? do #this checks to see if the next key is present in the nasa json
          @data = parsed_report["results"] #this parses the results of the json
          @data.each do |x| # takes each set of data from every terestria_date over the past year and creates opjects that contain the data
            MarsReport.create(terrestrial_date: x["terrestrial_date"], sol: x["sol"], ls: x["ls"], min_temp: x["min_temp"],
                               min_temp_fahrenheit: ["min_temp_fahrenheit"], max_temp: x["max_temp"], max_temp_fahrenheit: x["max_temp_fahrenheit"],
                               pressure: x["pressure"], pressure_string: x["pressure_string"], wind_speed: x["wind_speed"],
                               season: x["season"])
          end
          # the url for the next ten json objects is the value from the "next" key in the json
          url1 = URI.parse(parsed_report["next"]) # this parses the url
          req1 = Net::HTTP::Get.new(url1.to_s) # sends the http get request
          res1 = Net::HTTP.start(url1.host, url1.port) { |http| http.request(req1) }
          @report1 = res1.body
          parsed_report = JSON.parse(@report1) # updates parsed_report to the new list of json objects from the Nasa rover
        end
        respond_with @report
      end

      def update_nasa_data
        url = URI.parse('http://marsweather.ingenology.com/v1/archive/?terrestrial_date_start=2016-1-20&terrestrial_date_end=2017-1-21')
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
        @report = res.body
        parsed_report = JSON.parse(@report)
        while parsed_report["next"].present? do #this checks to see if the next key is present in the nasa json
         @data = parsed_report["results"] #this parses the results of the json
         @data.each do |x|
          @z = MarsReport.find_by(terrestrial_date: x["terrestrial_date"])
          @z.update_attributes!(sunrise: x["sunrise"],sunset: x["sunset"], wind_direction: x["wind_direction"])
         end
         url1 = URI.parse(parsed_report["next"]) #uses the url from the next json list from nasa
         req1 = Net::HTTP::Get.new(url1.to_s)
         res1 = Net::HTTP.start(url1.host, url1.port) { |http| http.request(req1) }
         @report1 = res1.body
         parsed_report = JSON.parse(@report1)
       end
       respond_with @report
     end

   end
 end
end
