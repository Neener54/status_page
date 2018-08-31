require 'bundler/setup'
require 'status_page'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'rspec'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

require 'rack/test'
require File.dirname(__FILE__) + '/fixtures/fake_app'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Rack::Test::Methods

  def app
    Rack::Lint.new(Rack::Test::FakeApp.new)
  end
end
