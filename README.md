# Acts as Hashable

[![Gem Version](https://badge.fury.io/rb/acts_as_hashable.svg)](https://badge.fury.io/rb/acts_as_hashable) [![Build Status](https://travis-ci.org/bluemarblepayroll/acts_as_hashable.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/acts_as_hashable) [![Maintainability](https://api.codeclimate.com/v1/badges/647dac37b9a8177f3d84/maintainability)](https://codeclimate.com/github/bluemarblepayroll/acts_as_hashable/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/647dac37b9a8177f3d84/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/acts_as_hashable/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a small library that helps increase the pliability of object constructor signatures.
Instead of instantiating via the constructor, this library can install helper factory
class-level methods that you can use with hashes:

* make(): create a single instance of a class
* array(): create an array of instances of a class

One caveat to this library is that it is not meant to be a complete modeling solution but rather
just a tool that helps model a domain or complete a modeling framework.
The main missing element to this library is that you still have to manage and implement constructors.
The two class-level factory methods are just meant to create a syntactic hash-like interface.

## Installation

To install through Rubygems:

````
gem install install acts_as_hashable
````

You can also add this to your Gemfile:

````
bundle add acts_as_hashable
````

## Examples

### Utilizing Classes on Hashabled Classes

Consider the following example:

````
class Person
  acts_as_hashable

  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age  = age
  end
end

class HeadOfHousehold
  acts_as_hashable

  attr_reader :person, :partner

  def initialize(person:, partner: nil)
    @person   = Person.make(person)
    @partner  = Person.make(partner)
  end
end

class Family
  acts_as_hashable

  attr_reader :head_of_household, :children

  def initialize(head_of_household:, children: [])
    @head_of_household  = HeadOfHousehold.make(head_of_household)
    @children           = Person.array(children)
  end
end
````

Simply placing:

````
acts_as_hashable
````

on a class means it will have the two main factory methods available for you to use.  Then,
you can leverage these for instantiation:

````
family = {
  head_of_household: {
    person: {
      name: 'Matt',
      age:  109,
    },
    partner: {
      name: 'Katie',
      age:  110,
    }
  },
  children: [
    { name: 'Martin', age: 29 },
    { name: 'Short',  age: 99 },
  ]
}

family_obj = Family.make(family)
````

The family_obj will then be a fully hydrated Family instance.  The family instance
attributes will also be fully hydrated since its constructor also uses acts_as_hashable.

Note that this works nicely with either keyword arguments or a hash-based argument constructor like so:

````
class Toy
  acts_as_hashable

  attr_reader :squishy

  def initialize(opts = {})
    @squishy = opts[:squishy] || false
  end
end

class Pet
  acts_as_hashable

  attr_reader :name, :toy

  def initialize(opts = {})
    @name = opts[:name]
    @toy  = Toy.make(opts[:toy])
  end
end
````

### Dynamic Factory Building

More complex relationships may contain objects with disparate types.  In this case we can use the included factory
pattern to help us build these.  Based on our examples above:

```ruby
class ExampleFactory
  acts_as_hashable_factory

  register 'Pet', Pet

  register 'HeadOfHousehold', HeadOfHousehold
end
```

Now we can dynamically build these using:

```ruby
objects = [
  {
    type: 'Pet',
    name: 'Doug the dog',
    toy: { squishy: true }
  },
  {
    type: 'HeadOfHousehold',
    person: {
      name: 'Matt',
      age: 109
    },
    partner: {
      name: 'Katie',
      age: 110
    }
  }
]

hydrated_objects = ExampleFactory.array(objects)
```

If the type key does not happen to be `type` then you can explicitly set this as:

```ruby
class ExampleFactory
  acts_as_hashable_factory

  type_key 'object_type'

  register 'Pet', Pet

  register 'HeadOfHousehold', HeadOfHousehold
end
```

You can also choose to pass in a proc/lambda instead of a class constant:

```ruby
class ExampleFactory
  acts_as_hashable_factory

  type_key 'object_type'

  register 'Pet', Pet

  register 'HeadOfHousehold', ->(_key) { HeadOfHousehold }
end
```

In case you need full control of the registry you can also choose to simply override the class-level `registry` method which will simply return a hash of keys (names) and values (class constants).

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check acts_as_hashable.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/acts_as_hashable.git)
4. Navigate to the root folder (cd acts_as_hashable)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update ```lib/acts_as_hashable/version.rb``` using [semantic versioning](https://semver.org/)
3. Install dependencies: ```bundle```
4. Update ```CHANGELOG.md``` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/acts_as_hashable/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
