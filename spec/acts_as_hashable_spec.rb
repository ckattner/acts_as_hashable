# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ActsAsHashable do
  let(:hydration_error) { ActsAsHashable::Hashable::HydrationError }

  context '#make' do
    context 'when passing in unacceptable input' do
      it 'should raise ArgumentError for number' do
        expect { Pet.make(1) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for string' do
        expect { Pet.make('') }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for true' do
        expect { Pet.make(true) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for array' do
        expect { Pet.make([]) }.to raise_error(ArgumentError)
      end
    end

    context 'with a hash constructor interface' do
      it 'should properly return object if object is already the same type' do
        original_pet_obj = Pet.new
        pet_obj = Pet.make(original_pet_obj)

        expect(pet_obj.hash).to eq(original_pet_obj.hash)
        expect(pet_obj.name).to be nil
        expect(pet_obj.toy).to be nil
      end

      it 'should properly return hydrated object if nil is passed in and is not nullable' do
        pet_obj = Pet.make(nil, nullable: false)

        expect(pet_obj.name).to be nil
        expect(pet_obj.toy).to be nil
      end

      it 'should properly return nil if nil is passed in and is nullable' do
        pet_obj = Pet.make(nil, nullable: false)

        expect(pet_obj.name).to be nil
        expect(pet_obj.toy).to be nil
      end

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
            age: 109
          },
          partner: {
            name: 'Katie',
            age: 110
          }
        }

        head_of_household_obj = HeadOfHousehold.make(head_of_household)

        expect(head_of_household_obj.person.name).to eq('Matt')
        expect(head_of_household_obj.person.age).to eq(109)
        expect(head_of_household_obj.partner.name).to eq('Katie')
        expect(head_of_household_obj.partner.age).to eq(110)
      end

      it 'should properly instantiate objects from string-keyed hash' do
        head_of_household = {
          'person' => {
            'name' => 'Matt',
            'age' => 109
          },
          'partner' => {
            'name' => 'Katie',
            'age' => 110
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
            age: 109
          },
          partner: {
            name: 'Katie',
            age: 110
          }
        }

        expect { HeadOfHousehold.make(head_of_household) }.to raise_error(hydration_error)
      end

      it 'should raise an ArgumentError for unknown required keyword' do
        head_of_household = {
          person: {
            name: 'Matt',
            age: 109,
            height_in_inches: 700
          },
          partner: {
            name: 'Katie',
            age: 110
          }
        }

        expect { HeadOfHousehold.make(head_of_household) }.to raise_error(hydration_error)
      end
    end

    context '#array' do
      it 'should properly create objects and arrays of objects from symbol-keyed hash and arrays' do
        family = {
          head_of_household: {
            person: {
              name: 'Matt',
              age: 109
            },
            partner: {
              name: 'Katie',
              age: 110
            }
          },
          children: [
            { name: 'Martin', age: 29 },
            { name: 'Short',  age: 99 }
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
              age: 109
            },
            partner: {
              name: 'Katie',
              age: 110
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

    context 'when the constructor has no arguments' do
      it 'hydrates with nil argument' do
        expect { ClassWithNoArguments.make(nil) }.not_to raise_error
      end

      it 'hydrates with empty hash argument' do
        expect { ClassWithNoArguments.make({}) }.not_to raise_error
      end

      it 'raises ArgumentError when an argument is tried to be passed in' do
        expect { ClassWithNoArguments.make({ something: :else }) }.to raise_error(hydration_error)
      end
    end
  end
end
