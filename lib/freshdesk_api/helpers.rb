# frozen_string_literal: true

module FreshdeskAPI
  # @private
  module Helpers
    def self.deep_hash_access(hash, path)
      path.split('/').each do |p|
        hash = if p.to_i.to_s == p
                 hash[p.to_i]
               else
                 hash[p.to_s] || hash[p.to_sym]
               end
        break unless hash
      end
      hash
    end
  end
end
