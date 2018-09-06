# Acts as Hashable

[![Build Status](https://travis-ci.org/bluemarblepayroll/acts_as_hashable.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/acts_as_hashable)

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
rspec spec --format documentation
````

## License

This project is MIT Licensed.
