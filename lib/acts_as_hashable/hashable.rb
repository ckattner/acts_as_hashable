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
    def array(object, nullable: true)
      objects = object.is_a?(Hash) ? [object] : Array(object)

      objects.select { |o| !!o }.map { |o| make(o, nullable: nullable) }
    end

    def make(object, nullable: true)
      if object.is_a?(Hash)
        new(**::ActsAsHashable::Utilities.symbolize_keys(object))
      elsif object.is_a?(self)
        object
      elsif object.nil? && nullable
        nil
      elsif object.nil? && !nullable
        new
      else
        raise "Cannot create hashable object with class name: #{object.class.name}"
      end
    end
  end
end
