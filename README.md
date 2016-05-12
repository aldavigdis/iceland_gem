# The Iceland Gem

The Iceland Gem handles Icelandic "kennitala" personal/entity identifiers and Icelandic postal codes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iceland'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iceland

## Usage

### Postal Codes

Names of locales are provided in dative form by default as per Icelandic postal convention, but nomative forms can be returned by setting the `force_nominative` parameter to `true` when using the `Iceland.all_postal_codes` and `Iceland.locale_by_postal_code` methods.

(Note that we use the term "locale" as per Universal Postal Union convention to name town, city or other location the postal code is assigned to.)

#### Examples

```ruby
# Get all postal codes, skipping codes assigned to P.O. boxes.
# This is useful when generating forms.
Iceland.all_postal_codes
# => [{:postal_code=>101, :locale=>"Reykjavík"}, {:postal_code=>103, [...]

# Get all postal codes, including P.O. boxes
Iceland.all_postal_codes true
# => [{:postal_code=>101, :locale=>"Reykjavík"}, {:postal_code=>103, [...]

# Get the name of locale based on its postal code.
# This is useful when you only save the postal code, but not the locale in a database.
Iceland.locale_by_postal_code 311
# => "Borgarnesi (dreifbýli)"

# Get the name of the locale in nominative form
Iceland.locale_by_postal_code 311, true
# => "Borgarnes (dreifbýli)"
```

### The Kennitala Class

The Iceland Gem provides a class to handle "kennitala" identifier codes. The class can be used to sanitize the identifiers and read information like the date of birth (or date of registration in the case of companies and organization), age and the type of entity.

#### Examples

```ruby
# Initialize a Kennitala object.
# The string provided may include spaces and hyphens.
k = Kennitala.new('010130-2989')
# => #<Kennitala:0x007fe35d041bc0 @value="0101302989">

# Invalid strings are rejected
f = Kennitala.new('010130-2979')
# ArgumentError: Kennitala is invalid

# Retrieve the kennitala as a string.
# This is a sanitized string, without any non-numeric characters.
k.to_s
# => "0101302989"

# Get the entity type (results in 'person' or 'entity')
k.entity_type
# => "person"

# Get the birth date or registration day as a Date object
k.to_date
# => #<Date: 1930-01-01 ((2425978j,0s,0n),+0s,2299161j)>

# Get the current age of entity. Useful for age restrictions.
k.age
# => 86
```

## Todo

* Administrative Divisions
* A Kennitala faker, similar to ffaker and ffaker

## About the data

The Postal code data is based on data files provided by Iceland Post. The files are available at http://www.postur.is/um-postinn/posthus/postnumer/gagnaskrar/ and are provided for free for any use by individuals and organizations.

Strings are expected to be UTF-8.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stefanvignir/iceland_gem.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
