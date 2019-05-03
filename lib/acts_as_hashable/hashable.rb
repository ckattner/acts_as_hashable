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

    HASHABLE_HYDRATORS = [
      {
        condition: ->(_context, object, _nullable) { object.is_a?(Hash) },
        converter: lambda do |context, object, _nullable|
          context.new(**(object || {}).symbolize_keys)
        end
      },
      {
        condition: ->(context, object, _nullable) { object.is_a?(context) },
        converter: ->(_context, object, _nullable) { object }
      },
      {
        condition: ->(_context, object, nullable) { object.nil? && nullable },
        converter: ->(_context, _object, _nullable) { nil }
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
        if hydrator[:condition].call(self, object, nullable)
          return hydrator[:converter].call(self, object, nullable)
        end
      end

      raise ArgumentError, "Cannot create hashable object with class name: #{object.class.name}"
    end
  end
end
