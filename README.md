# Acts as Hashable

This is a small library that helps increase the pliability of object constructor signatures.
Instead of instantiating via the constructor, this library can install helper factory
class-level methods that you can use with hashes:

* make(): create a single instance of a class
* array(): create an array of instances of a class

One caveat to this library is that it is not meant to be a complete modeling solution but rather
just a tool that helps model a domain or complete a modeling framework.
The main missing element to this library is that you still have to manage and implement constructors.
The two class-level factory methods are just meant to create a syntactic hash-like interface.

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

### Resolving Constants at Runtime

Factories can also be resolved using Ruby's Object#const_get and Object#const_missing.  Simply register a string  representing the class in order to use these mechanics, such as:

```ruby
class ExampleFactory
  acts_as_hashable_factory

  type_key 'object_type'

  register 'Pet', 'Pet'

  register 'HeadOfHousehold', ->(_key) { HeadOfHousehold }
end
```

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
bundle exec spec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publication
---

The publication procedure has these main parts:

1. Merge
2. Version
3. Tag

An example of how this can be done from the root directory:

1. Checkout master locally: `git checkout master`
2. Update master: `git pull origin master`
3. Merge in your feature branch: `git merge <FEATURE_BRANCH_NAME>`
4. Update the version in: `version.rb` [follow semantic versioning](http://www.semver.org).  This step takes a little coordination so you do not have versioning conflicts with other developers features.  Make sure you pick the right version major, minor, and patch.
5. Add update notes to `CHANGELOG.md`.  List all additions, changes, etc.
6. Bundle the Gemfile: `bundle`
7. Commit changes: `git commit -am "publishing version <X.X.X> for story ABC ..."`
8. Tag new version: `git tag <X.X.X>`.  Tag should be identical to the version you set in step 5 above.
9. Push up changes: `git push origin master`
10. Push up tag: `git push origin <X.X.X>`
11. Package and publish: `bundle exec rake release`.  Note: the `bluemarblepayroll_api_key` entry must be present with a valid gems.bluemarblepayroll.com API key.  To add a key to your gem credentials file, run: `echo "\n:bluemarblepayroll_api_key: <KEY>" >> ~/.gem/credentials`
