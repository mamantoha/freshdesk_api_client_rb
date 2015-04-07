module FreshdeskAPI
  # @private
  module Helpers
    def self.deep_hash_access(hash, path)
      path.split('/').each do |p|
        if p.to_i.to_s == p
          hash = hash[p.to_i]
        else
          hash = hash[p.to_s] || hash[p.to_sym]
        end
        break unless hash
      end
      hash
    end
  end
end
