require 'redis'
require 'spec_helper'
RSpec.describe StatusPage do
  before :each do
    @redis = Redis.new
  end

  describe "StatusPage::Collector" do
    describe 'successful requests' do
      it "increases the value of the request count when a request is made" do
        count = @redis.get('request_count').to_i
        get '/'
        expect(last_response.status).to be(200)
        expect(@redis.get('request_count').to_i).to be(count + 1)
      end
    end
    describe 'error requests' do
      it 'increases the value of the error count when a bad request is made' do
        count = @redis.get('error_count').to_i
        get '/error'
        expect(last_response.status).to be(500)
        expect(@redis.get('error_count').to_i).to be( count + 1 )
      end

      it 'increases the count of the requests when a bad request is made' do
        count = @redis.get('request_count').to_i
        get '/error'
        expect(last_response.status).to be(500)
        expect(@redis.get('request_count').to_i).to be(count + 1)
      end
    end
  end

  describe "StatusPage::Reporter" do
    # TODO setup webmock and test these changes.
  end
end
