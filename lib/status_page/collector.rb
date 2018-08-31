require 'redis'
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