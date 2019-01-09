require 'redis'
# Collector is the class that we use to push metrics into the redis instance.
# This is a simple rack middleware that we want to make sure to insert
# into the chain where all requests can go from top to bottom.
# @author Michael Archibald
# @attr [RackApp] app Rack App
# @attr [Redis] redis Redis instance to interact with
#
# Add this to your app by adding this line to your rails config or your Rack file
#
# use StatusPage::Collector, redis_url: "redis://localhost"
module StatusPage
  class Collector

    def initialize(app, redis_url:)
      @app = app
      @redis = Redis.new(url: redis_url)
      @redis.set('error_count', 0) unless @redis.exists('error_count')
      @redis.set('request_count', 0)  unless @redis.exists('request_count')
    end

    def call(env)
      status, headers, response = @app.call(env)
      @redis.incr('request_count')
      @redis.incr('error_count') unless [200,201,204].include?(status)
      [status, headers, response]
    end
  end
end
