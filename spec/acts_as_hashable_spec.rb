#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './lib/acts_as_hashable'

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

describe ActsAsHashable do
  context '#make' do

    context 'with a hash constructor interface' do

      it 'should properly instantiate objects from a symbol-keyed hash' do

        pet = {
          name: 'Doug the dog',
          toy: { squishy: true }
        }

        pet_obj = Pet.make(pet)

        expect(pet_obj.name).to eq('Doug the dog')
        expect(pet_obj.toy.squishy).to be true
      end

    end

    context 'with keyword arguments interface' do

      it 'should properly instantiate objects from symbol-keyed hash' do
        head_of_household = {
          person: {
            name: 'Matt',
            age:  109,
          },
          partner: {
            name: 'Katie',
            age:  110,
          }
        }

        head_of_household_obj = HeadOfHousehold.make(head_of_household)

        expect(head_of_household_obj.person.name).to eq('Matt')
        expect(head_of_household_obj.person.age).to eq(109)
        expect(head_of_household_obj.partner.name).to eq('Katie')
        expect(head_of_household_obj.partner.age).to eq(110)
      end

      it 'should properly instantiate objects from symbol-keyed hash' do
        head_of_household = {
          'person'  => {
            'name'  => 'Matt',
            'age'   => 109,
          },
          'partner' => {
            'name'  => 'Katie',
            'age'   =>  110,
          }
        }

        head_of_household_obj = HeadOfHousehold.make(head_of_household)

        expect(head_of_household_obj.person.name).to eq('Matt')
        expect(head_of_household_obj.person.age).to eq(109)
        expect(head_of_household_obj.partner.name).to eq('Katie')
        expect(head_of_household_obj.partner.age).to eq(110)
      end

      it 'should raise an ArgumentError for missing required keyword' do
        head_of_household = {
          person: {
            # name: 'Matt',
            age:  109,
          },
          partner: {
            name: 'Katie',
            age:  110,
          }
        }

        expect { HeadOfHousehold.make(head_of_household) }.to raise_error(ArgumentError)
      end

      it 'should raise an ArgumentError for unknown required keyword' do
        head_of_household = {
          person: {
            name: 'Matt',
            age:  109,
            height_in_inches: 700,
          },
          partner: {
            name: 'Katie',
            age:  110,
          }
        }

        expect { HeadOfHousehold.make(head_of_household) }.to raise_error(ArgumentError)
      end

    end

    context '#array' do

      it 'should properly instantiate objects and arrays of objects from symbol-keyed hash and arrays' do
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

        expect(family_obj.head_of_household.person.name).to   eq('Matt')
        expect(family_obj.head_of_household.person.age).to    eq(109)
        expect(family_obj.head_of_household.partner.name).to  eq('Katie')
        expect(family_obj.head_of_household.partner.age).to   eq(110)

        expect(family_obj.children.length).to  eq(2)
        expect(family_obj.children[0].name).to eq('Martin')
        expect(family_obj.children[0].age).to  eq(29)
        expect(family_obj.children[1].name).to eq('Short')
        expect(family_obj.children[1].age).to  eq(99)
      end

      it 'should properly instantiate arrays of objects when only a single hash is passed in' do
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
          children: { name: 'Martin', age: 29 }
        }

        family_obj = Family.make(family)

        expect(family_obj.head_of_household.person.name).to   eq('Matt')
        expect(family_obj.head_of_household.person.age).to    eq(109)
        expect(family_obj.head_of_household.partner.name).to  eq('Katie')
        expect(family_obj.head_of_household.partner.age).to   eq(110)

        expect(family_obj.children.length).to  eq(1)
        expect(family_obj.children[0].name).to eq('Martin')
        expect(family_obj.children[0].age).to  eq(29)
      end

    end
  end
end
