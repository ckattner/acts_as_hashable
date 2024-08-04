# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'caution'
require 'forwardable'

require_relative 'acts_as_hashable/factory'
require_relative 'acts_as_hashable/hash_refinements'
require_relative 'acts_as_hashable/type_factory'
require_relative 'acts_as_hashable/hashable'

module ActsAsHashable
  # This module adds the class-level method that marks a class as hashable.
  module DslHook
    def acts_as_hashable
      extend ::ActsAsHashable::Hashable
    end

    def acts_as_hashable_factory
      extend ActsAsHashable::Factory
    end
  end
end

Object.class_eval do
  extend ActsAsHashable::DslHook
end
