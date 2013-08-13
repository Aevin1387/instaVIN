require "httparty"

module InstaVIN
  class Reports
    include HTTParty
    base_uri "https://www.instavin.com/api/v2/json"


    def initialize(access_token=nil)
      if access_token.nil? != true
        @auth = { username: access_token, password: InstaVIN.config.api_key }
      else
        @auth = { username: InstaVIN.config.username, password: InstaVIN.config.password }
      end
    end

    def set_auth_with_token(access_token)
      @auth = { username: access_token, password: InstaVIN.config.api_key }
    end

    def order_report(report_type, options)
      raise ArgumentError, "A VIN is required" if options[:vin].nil? || options[:vin].empty?

      response = self.class.post("/order/#{report_type}", { body: options, basic_auth: @auth })
      parsed_response = response.parsed_response
      check_response_for_errors parsed_response
      parsed_response["items"].map do |report_item|
        check_report_for_error report_item

        raise NoDataError if report_item["report_summary"].nil?
        report_summary = report_item["report_summary"]
        {
          vin: report_summary["vin"],
          json_url: report_summary["url"],
          html_url: report_summary["html_url"],
          pdf_url: report_summary["pdf_url"]
        }
      end
    end

    def vtr_report(vin)
      order_report("VTR", vin: vin)
    end

    def svc_report(vin)
      order_report("SVC", vin: vin)
    end

    def access_token(username, password)
      response = self.class.post("/account/access_token",
        body: { api_key: InstaVIN.config.api_key },
        basic_auth: { username: username, password: password }
      ).parsed_response

      check_response_for_errors(response)
      raise DeveloperError, "InstaVIN did not respond with an access token" if response["token"].nil? || response["token"].empty?
      response["token"]
    end

    private

    def check_response_for_errors(response)
      raise DowntimeError, "InstaVIN is down for #{response["reason"]} until approximately #{response["down_until"]}." if(response["_type"] == "downtime")
      raise DeveloperError, "#{response["status_code"]}: #{response["error_message"]}" if response["_type"] == "error"
    end

    def check_report_for_error(report)
      return unless report["state"] == "error"
      raise NoDataError if report["detail_code"] == "NO_DATA_AVAILABLE"
      raise DeveloperError, "InstaVIN Report Error #{report["detail_code"]}"
    end
  end
end
