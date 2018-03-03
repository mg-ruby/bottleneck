# Bottleneck

Bottleneck - simple Redis based requests limiter with two params:

*  time_period_seconds: 3600
*  max_requests_count: 100

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bottleneck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bottleneck

## Usage

Create two yaml files in config dir:

**bottleneck.yml**

limits:
  time_period_seconds: 3600
  max_requests_count: 100

**redis.yml**
host: 'localhost'
port: 6379

Add before action:
class ApplicationController < ActionController::API
  before_action :check_limit

  private

  def check_limit
    result = Bottleneck.check(request)
    render status: result[:status], json: { message: result[:message] }
  end
end

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maratgaliev/bottleneck. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
