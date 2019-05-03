# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  # A TypeFactory object understands how to build objects using a special designated 'type' key.
  class TypeFactory
    using HashRefinements

    DEFAULT_TYPE_KEY = :type

    attr_reader :registry, :type_key

    def initialize(registry = {}, type_key = DEFAULT_TYPE_KEY)
      @registry = registry.symbolize_keys
      @type_key = type_key.to_s.to_sym

      freeze
    end

    def array(objects = [])
      objects = objects.is_a?(Hash) ? [objects] : Array(objects)

      objects.map do |object|
        object.is_a?(Hash) ? make(object) : object
      end
    end

    def make(config = {})
      config        = (config || {}).symbolize_keys
      type          = config[type_key].to_s.to_sym
      object_class  = registry[type]

      raise ArgumentError, "cannot find section from type: #{type}" unless object_class

      config_without_type = config.reject { |k| k == type_key }

      object_class.new(config_without_type)
    end
  end
end
