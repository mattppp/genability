require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response do

  before(:all) do
    VCR.turn_off!
  end
  after(:all) do
    VCR.turn_on!
  end

  before do
    @client = Genability::Client.new({:application_id => 'ValidAppID', :application_key => 'ValidAppKey'})
  end

  {
    400 => Genability::BadRequest,
    401 => Genability::Unauthorized,
    403 => Genability::Forbidden,
    404 => Genability::NotFound,
    500 => Genability::ServerError,
    503 => Genability::ServiceUnavailable
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before(:each) do
        body = {
          status: "error",
          count: 1,
          type: "Error",
          results: [{
            code: "404",
            message: "Message"
          }]
        }
        stub_request(:get, /.*\/public\/lses/).
          to_return(:status => status, :body => body.to_json)
      end

      it "should raise #{exception.name} error" do
        lambda do
          @client.load_serving_entities()
        end.should raise_error(exception)
      end
    end
  end

  context "when response is not JSON-formatted" do
    before(:each) do
      stub_request(:get, /.*\/public\/lses/).
        to_return(:status => 200, :body => "this is a bad response")
    end

    it "should raise Genability::InvalidResponseFormat" do
      lambda do
        @client.load_serving_entities()
      end.should raise_error(Genability::InvalidResponseFormat, /this is a bad response/)
    end

  end
end

