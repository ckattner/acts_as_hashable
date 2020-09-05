# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  # This class serves as a singleton that can make mapped acts_as_hashable components.
  # It is important to note that these components *must* be acts_as_hashable objects.
  # In order to use you just have to subclass this class and implement
  # a method called 'registry', such as:
  #   def registry
  #     {
  #       'Table': Table,
  #       'Text': Text
  #     }
  #   end
  # You can also use the 'register' DSL:
  #   register 'some_class_name', SomeClassName
  #   register 'some_class_name', '', SomeClassName
  # or:
  #   register 'some_class_name', ->(_key) { SomeClassName }
  module Factory
    extend Forwardable

    def_delegators :factory, :array, :make

    def register(*args)
      raise ArgumentError, "missing at least one key and value: #{args}" if args.length < 2

      value = args.last

      args[0..-2].each do |key|
        registry[key] = value
      end
    end

    def registry # :nodoc:
      @registry ||= {}
    end

    def materialize_registry # :nodoc:
      @registry.map do |k, v|
        value = v.is_a?(Proc) ? v.call(k) : v
        [k, value]
      end.to_h
    end

    def type_key(key) # :nodoc:
      @typed_with = key
    end

    def typed_with # :nodoc:
      @typed_with || TypeFactory::DEFAULT_TYPE_KEY
    end

    private

    def factory
      @factory ||= TypeFactory.new(materialize_registry, typed_with)
    end
  end
end
