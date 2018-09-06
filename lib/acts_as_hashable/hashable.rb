#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  module Hashable

    def array(object, nullable: true)
      if object.is_a?(Hash)
        objects = [ object ]
      else
        objects = Array(object)
      end

      objects.select { |o| !!o }.map { |o| make(o, nullable: nullable) }
    end

    def make(object, nullable: true)
      if object.is_a?(Hash)
        self.new(**::ActsAsHashable::Utilities.symbolize_keys(object))
      elsif object.is_a?(self)
        object
      elsif object.nil? && nullable
        nil
      elsif object.nil? && !nullable
        self.new
      else
        raise "Cannot create hashable object with class name: #{object.class.name}"
      end
    end

  end
end
