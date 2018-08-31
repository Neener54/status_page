require 'rubygems'
require 'sinatra/base'
require 'status_page'
module Rack
  module Test
    class FakeApp < Sinatra::Base
      use StatusPage::Collector, redis_url: "redis://localhost"
      head '/' do
        'meh'
      end

      options '/' do
        [200, {}, '']
      end

      get '/' do
        "Hello, GET: #{params.inspect}"
      end

      get '/error' do
        [500, {}, '']
      end
    end
  end
end