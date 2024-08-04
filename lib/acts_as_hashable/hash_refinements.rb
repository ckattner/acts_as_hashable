# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  # Let's provide a refinenment instead of monkey-patching Hash.  That way we can stop
  # polluting other libraries and internalize our specific needs.
  module HashRefinements # :nodoc: all
    refine Hash do
      def symbolize_keys
        transform_keys(&:to_sym)
      end
    end
  end
end
