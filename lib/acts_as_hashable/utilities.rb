#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module ActsAsHashable
  class Utilities
    class << self

      # https://apidock.com/rails/Hash/symbolize_keys
      def symbolize_keys(hash)
        transform_keys(hash) { |key| key.to_sym rescue key }
      end

      # https://apidock.com/rails/v4.2.7/Hash/transform_keys
      def transform_keys(hash)
        return enum_for(:transform_keys) unless block_given?

        result = {}

        hash.keys.each do |key|
          result[yield(key)] = hash[key]
        end

        result
      end

    end
  end
end
