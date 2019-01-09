require 'httparty'
require 'redis'

# This class exists to send data to StatusPage.io
# @author Michael Archibald
# @attr [String]  api_key The API key for StatusPage.io
# @attr [String] page_id The page ID from StatusPage.io
# @attr [String] metric_id the metric id for the metric you're reporting
# @attr [String] api_base the api base for your statuspage request
# @attr [String] redis_url the url for the redis instance you'll be pulling metrics from. It should be the same as
#                the redis_url in the Collector
# @attr [String] error_metrics_id the metric id for the errors you'd like to report
# @attr [String] request_metric_id the id for the request metrics we will send to StatusPage
#
# The configuration in the app should look something like this:
# Status::Reporter.new do |c|
#     c.api_key = ENV['API_KEY']
#     c.page_id = ENV['PAGE_ID']
#     c.metric_id = ENV['METRIC_ID']
#     c.api_base = ENV['API_BASE']
#     c.redis_url = ENV['REDIS_URL']
#     c.error_metric_id = ENV['ERROR_METRIC_ID']
#     c.request_metric_id = ENV['REQUEST_METRIC_ID']
# end
# Rack::App.middleware.use(Status::Collector)

module StatusPage
  class Reporter

    attr_accessor :api_key,
                  :page_id,
                  :metric_id,
                  :api_base,
                  :redis_url,
                  :error_metric_id,
                  :request_metric_id

    def self.report(&config)
      reporter = new(&config)
      reporter.report
    end

    def initialize
      yield(self)
      @redis = Redis.new(url: redis_url )
    end

    def report
      report_errors
      report_requests
    end

    def report_requests
      metric_hash = {
          timestamp: Time.now.to_i,
          value: @redis.get('request_count')
      }

      post_request @request_metric_id, metric_hash

      @redis.set('request_count', 0)
    end

    def report_errors
      metric_hash = {
          timestamp: Time.now.to_i,
          value: @redis.get('error_count')
      }

      post_request(@error_metric_id, metric_hash)

      @redis.set('error_count', 0)
    end

    def post_request(metric_id, metrics={})
      HTTParty.post(
          "#{@api_base}/pages/#{@page_id}/metrics/#{metric_id}/data.json",
          headers: {
              'Authorization' => "OAuth #{@api_key}",
          },
          body: {
              data: metrics
          }
      )
    end
  end
end
