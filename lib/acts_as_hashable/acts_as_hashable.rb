#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'utilities'
require_relative 'hashable'

module ActsAsHashable
  module DslHook
    def acts_as_hashable
      extend ::ActsAsHashable::Hashable
    end
  end
end

Object.class_eval do
  extend ::ActsAsHashable::DslHook
end
