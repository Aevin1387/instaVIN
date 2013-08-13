require_relative "../minitest_helper"

describe InstaVIN::Reports do
  let(:username) { "username" }
  let(:password) { "password" }
  let(:api_key) { "api_key" }
  let(:access_token) { "access_token" }

  before do
    InstaVIN.configure do |config|
      config.username = username
      config.password = password
      config.api_key = api_key
    end
  end

  let(:reports) { InstaVIN::Reports.new }
  let(:vin) { "1D7HW22K45S177616" }

  describe "using configured user" do
    it "can get a vtr report" do
      VCR.use_cassette("user_vtr_report_success") do
        response = reports.vtr_report(vin).first
        response.must_include :html_url
        response.must_include :json_url
        response.must_include :pdf_url
      end
    end

    it "can get an access token" do
      VCR.use_cassette("user_access_token_success") do
        response = reports.access_token(InstaVIN.config.username, InstaVIN.config.password)
        assert_equal response, access_token
      end
    end

    it "should raise an error if the vin is invalid" do
      VCR.use_cassette("user_vtr_invalid_vin") do
        proc { reports.vtr_report("INVALID_VIN") }.must_raise InstaVIN::NoDataError
      end
    end
  end

  describe "using an access token" do
    before do
      reports.set_auth_with_token(access_token)
    end

    it "can get a vtr report" do
      VCR.use_cassette("access_vtr_report_success") do
        response = reports.vtr_report(vin).first
        response.must_include :html_url
        response.must_include :json_url
        response.must_include :pdf_url
      end
    end
  end
end
