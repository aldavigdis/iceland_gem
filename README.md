# The Iceland Gem

The Iceland Gem is a metapackage for the `Kennitala` and `Postnumer` gems.

It is recommended that you use those gems instead. This gems remains online for
backwards-compatibility reasons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iceland'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iceland

## Change log

* v2.0.0 - This gem has been changed into a metapackage for the `Kennitala` and `Postnumer` gems.

## Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stefanvignir/iceland_gem.

Do make sure that the `rspec` unit tests run before sending a pull request and write tests for any new functionality you add. Also run `rubocop` to check if your code adheres to the Ruby Style Guide and other conventions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
