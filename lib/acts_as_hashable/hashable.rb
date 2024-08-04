# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  # This class contains the main set of class-level methods that can be used by
  # hashable classes.
  module Hashable
    using HashRefinements

    class HydrationError < Caution::CauseInjectingError; end

    HASHABLE_HYDRATORS = [
      {
        condition: ->(_context, object, _nullable) { object.is_a?(Hash) },
        converter: lambda do |context, object, _nullable|
          args = (object || {}).symbolize_keys

          if args.keys.any?
            context.new(**args)
          else
            context.new
          end
        end
      },
      {
        condition: ->(context, object, _nullable) { object.is_a?(context) },
        converter: ->(_context, object, _nullable) { object }
      },
      {
        condition: ->(_context, object, nullable) { object.nil? && nullable },
        converter: ->(_context, _object, _nullable) {}
      },
      {
        condition: ->(_context, object, nullable) { object.nil? && !nullable },
        converter: ->(context, _object, _nullable) { context.new }
      }
    ].freeze

    private_constant :HASHABLE_HYDRATORS

    def array(object, nullable: true)
      objects = object.is_a?(Hash) ? [object] : Array(object)

      objects.reject { |o| o.is_a?(FalseClass) || o.nil? }
             .map { |o| make(o, nullable: nullable) }
    end

    def make(object, nullable: true)
      HASHABLE_HYDRATORS.each do |hydrator|
        next unless hydrator[:condition].call(self, object, nullable)

        return hydrate(hydrator, object, nullable)
      end

      raise ArgumentError, "Cannot create hashable object with class name: #{object.class.name}"
    end

    private

    def hydrate(hydrator, object, nullable)
      hydrator[:converter].call(self, object, nullable)
    rescue ArgumentError
      raise HydrationError, "#{name} cannot be hydrated using arguments: #{object}"
    end
  end
end
