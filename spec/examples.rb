# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

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

class ClassWithNoArguments
  acts_as_hashable
end

class ExampleFactory
  acts_as_hashable_factory

  type_key :object_type

  register 'Person', Person
  register 'Pet', Pet
  register 'Toy', 'Toy' # test out string constantization
  register 'class_with_no_arguments', ClassWithNoArguments

  # These are examples of registering a proc instead of a class constant.  It
  # will send the key through the argument if you need
  register 'Familiy', ->(_key) { Family }

  register 'HeadOfHousehold', ->(_key) { HeadOfHousehold }
end
