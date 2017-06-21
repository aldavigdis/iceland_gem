[![Build Status](https://travis-ci.org/stefanvignir/iceland_gem.svg)](https://travis-ci.org/stefanvignir/iceland_gem)
[![Test Coverage](https://codeclimate.com/github/stefanvignir/iceland_gem/badges/coverage.svg)](https://codeclimate.com/github/stefanvignir/iceland_gem/coverage)
[![Code Climate](https://codeclimate.com/github/stefanvignir/iceland_gem/badges/gpa.svg)](https://codeclimate.com/github/stefanvignir/iceland_gem)

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

Icelandic postal codes are 3-digit numeric identifiers, with the first digit indicating a region and the rest identifying a specific locale within the region.

Names of locales are provided in dative form by default as per Icelandic postal convention, but nomative forms can be returned by setting the `force_nominative` parameter to `true` when using the `Iceland.all_postal_codes` and `Iceland.locale_by_postal_code` methods.

(Note that we use the term "locale" as per Universal Postal Union convention to name the town, city or other location the postal code is assigned to.)

#### Examples

```ruby
# Get all postal codes, skipping codes assigned to P.O. boxes.
# This is useful when generating forms.
Iceland::PostalCode.list
# => [{:postal_code=>101, :locale=>"Reykjavík"}, {:postal_code=>103, [...]

# Get the same postal codes in nomative form
Iceland::PostalCode.list(nominative: true)
# => [{:postal_code=>101, :locale=>"Reykjavík"}, {:postal_code=>103, [...]

# Get all postal codes, including P.O. boxes
Iceland::PostalCode.list(include_po_boxes: true)
# => [{:postal_code=>101, :locale=>"Reykjavík"}, {:postal_code=>103, [...]

# Get the name of locale based on its postal code.
# This is useful when you only save the postal code, but not the locale in a database.
Iceland::PostalCode.find_locale(311)
# => "Borgarnesi (dreifbýli)"

# Get the name of the locale in nominative form
Iceland.find_locale(postal_code: 311, nominative: true)
# => "Borgarnes (dreifbýli)"
```

### The Kennitala Class

The Iceland Gem provides a class to handle "kennitala" identifier codes. The class can be used to sanitize the identifiers and read information like the date of birth (or date of registration in the case of companies and organization), age and the type of entity.

The class does not access external APIs or databases such National Registry or the Company Registry, so names and status (sex/gender, death, bankruptcy, credit rating etc.) cannot be accessed using the class. However, it can be used to sanitize and validate such data before being sent to external APIs, as such services are provided by private companies, which often charge a specific amount for each query.

#### Uses of kennitala

Unlike the US Social Security number and equivalents, the kennitala is only used for identification of persons and companies (as well as other registered organizations) — and is often used internally by educational institutions, companies and other organization as a primary identifier for persons (e.g. school, employee, customer and frequent flyer ID). It is not to be used for authentication (i.e. a password) and is not considered a secret per se. While a kennitala can be kept unencrypted in a database, publishing a kennitala or a list of them is generally not considered good practice and might cause liability.

A kennitala is assigned to every newborn person and foreign nationals residing in Iceland as well as organizations and companies operating there. It is statically assigned and can not be changed.

Article II, paragraph 10 of the 77/2000 Act on Data Protection (http://www.althingi.is/lagas/nuna/2000077.html) provides the legal framework regarding the use and processing of the kennitala in Iceland:

> The use of a kennitala is allowed if it has a an objective cause and is necessary to ensure reliable identification of persons. The Data Protection Authority may ban or order the use of kennitala.

#### Technicalities

The kennitala (`DDMMYY-RRCM`) is a 10-digit numeric string consisting on a date (date of birth for persons, date of registration for companies) in the form of `DDMMYY`, three two random digits (`RR`) a check digit (`C`) and a century identifier (`M`). A hyphen or space is often added between the year and random values (Example: `010130-2989`).

The number 40 is added to the registration day of companies and organizations. Hence, a kennitala for a company registered at January 1 1990 starts with `410190` as opposed to `010190` for a person born that day.

The century identifier has 3 legal values. `8` for the 19th century, `9` for the 20th century and `0` for the 21st century.

#### Examples

##### Working with Kennitala objects

```ruby
# Initialize a Kennitala object.
# The string provided may include spaces, hyphens and alphabetical characters,
# which will then be erased from the resulting string.
k = Iceland::Kennitala.new(' 010130-2989')
# => #<Kennitala:0x007fe35d041bc0 @value="0101302989">

# Invalid strings are rejected with an argument error
f = Iceland::Kennitala.new('010130-2979')
# => ArgumentError: Kennitala is invalid

# If no kennitala string is specified, a random one will be generated
r = Iceland::Kennitala.new
# => #<Kennitala:0x007fc589339f18 @value="2009155509">

# Retrieve the kennitala as a string.
# This is a sanitized string, without any non-numeric characters.
# Pretty useful when storing it in a database.
k.to_s
# => "0101302989"

# Pretty print the kennitala
# Adds a space between the 6th and the 7th digits for readability
k.pp
# => "010130 2989"

# You can also pass a string to .pp to use as a spacer
k.pp('–')
# => "010130-2989"

# You can also pass a cat to the .pp method
k.pp('🐈')
# => "010130🐈2989"

# Get the entity type (results in 'person' or 'company')
k.entity_type
# => "person"

# It's also possible to use .company and .person to achieve the same thing
k.company?
# => false

k.person?
# => true

# Cast the kennitala to a Date object
k.to_date
# => #<Date: 1930-01-01 ((2425978j,0s,0n),+0s,2299161j)>

# Get the current age of the entity. Useful for age restrictions.
k.age
# => 86
```

##### Casting strings

```ruby
# Casting a string to a Kennitala object
'010130 2989'.to_kt
# => #<Kennitala:0x007fc5893286a0 @value="0101302989">

# Get the current age based on a String
'0101302989'.to_kt.age
# => 86
```

## Todo

* Split the gem into modules and make the this gem a collection gem, depending on and thus including all the others
* Initialization ob objects and instance methods for the `Iceland::PostalCode` class
* Add Administrative Divisions

## About the data

The Postal code data is based on data files provided by Iceland Post. The files are available at http://www.postur.is/um-postinn/posthus/postnumer/gagnaskrar/ and are provided for free for any use by individuals and organizations.

Strings are expected to be UTF-8.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stefanvignir/iceland_gem.

Do make sure that the `rspec` unit tests run before sending a pull request and write tests for any new functionality you add. Also run `rubocop` to check if your code adheres to the Ruby Style Guide and other conventions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
