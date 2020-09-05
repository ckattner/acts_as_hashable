# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'constant_resolver'

module ActsAsHashable
  # A TypeFactory object understands how to build objects using a special designated 'type' key.
  class TypeFactory
    using HashRefinements

    DEFAULT_TYPE_KEY = :type

    attr_reader :registry, :type_key

    def initialize(registry = {}, type_key = DEFAULT_TYPE_KEY)
      @constant_resolver = ConstantResolver.new
      @registry          = registry.symbolize_keys
      @type_key          = type_key.to_s.to_sym

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
      object_class  = resolve_object_class(type)

      config_without_type = config.reject { |k| k == type_key }

      # We want to defer to the classes proper maker if it exists.
      # Technically, this factory should only make classes that include Hashable, but just to be
      # sure we do not break any existing compatibility, lets make it work for both.
      method_name = object_class.respond_to?(:make) ? :make : :new

      object_class.send(method_name, config_without_type)
    end

    private

    attr_reader :constant_resolver

    def resolve_object_class(type)
      object_class = registry[type]

      raise ArgumentError, "cannot find registration for: '#{type}'" unless object_class

      return object_class unless object_class.is_a?(String)

      constant_resolver.constantize(object_class)
    end
  end
end
