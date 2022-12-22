# Candid client

Unofficial client library for working with the [Candid charity API](https://developer.candid.org)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'candid-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install candid-client

## Usage

Only the Premier v3 API is supported at this time. Pull requests are welcome for other versions.

### Premier v3

**Setup**

Once this gem has been installed and you have the required credentials, you must place Candid Premier v3 configuration early in your app's boot process (eg: a Rails initializer):

```ruby
Candid::PremierV3.configure do |config|
    config.api_token = 'letmein'
end
```

**Usage**

As with the API, there is only one method exposed for use:

```ruby
charity_details = Candid::PremierV3.lookup_by_ein('12-3456789')

puts charity_details.summary.organization_name
puts charity_details.operations.leader_name
```

This returns a `Candid::PremierV3::Resource` object that automatically allows you to access the data using the dot notation. If you need to access the raw data, you can use the `#to_h` method. The resource's data is scoped to the `data` key in the response - you have access to the full response by using the `#response` method.

**Errors**

If the API returns an error, a `Candid::PremierV3::APIError` will be raised. The error object will a message set by the API and a `#response` method that returns the full response object.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If you prefer to use Docker, you can start a container with `docker compose up` and then run `docker compose exec gem bash` to get a shell in the container.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Percent-Pledge/candid-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
