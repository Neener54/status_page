require 'httparty'
require 'redis'
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