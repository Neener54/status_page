# StatusPage

This Gem includes a basic setup to report stats to StatusPage.io. 
## Installation
Redis is currently a requirement for the project although I have plans to make that optional at some point.
You'll have to have a working instance of redis available.

Add this line to your application's Gemfile:

```ruby
gem 'status_page'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install status_page

## Usage

To use add the following to either your rack app or rails app:

    Status::Reporter.new do |c|
        c.api_key = ENV['API_KEY']
        c.page_id = ENV['PAGE_ID']
        c.metric_id = ENV['METRIC_ID']
        c.api_base = ENV['API_BASE']
        c.redis_url = ENV['REDIS_URL']
        c.error_metric_id = ENV['ERROR_METRIC_ID']
        c.request_metric_id = ENV['REQUEST_METRIC_ID']
    end
Then add

    Rack::App.middleware.use Status::Collector, redis_url: ENV['REDIS_URL']
Or in a rails app

    config.middleware.insert_after Rack::Sendfile, Status::Collector, {redis_url: ENV['REDIS_URL']}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Neener54/status_page. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StatusPage project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Neener54/status_page/blob/master/CODE_OF_CONDUCT.md).
