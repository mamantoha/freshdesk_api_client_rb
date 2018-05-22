# frozen_string_literal: true

require 'freshdesk_api/actions'

module FreshdeskAPI
  # Represents a resource that only holds data.
  class Data
    # @return [Hash] The resource's attributes
    attr_reader :attributes

    # @return [Array] The last received errors
    attr_accessor :errors

    class << self
      # The singular resource name taken from the class name (e.g. FreshdeskAPI::SoulutionCategory -> solution_category)
      def singular_resource_name
        @singular_respurce_name ||= to_s.split('::').last.underscore
      end

      # The resource name taken from the class name (e.g. FreshdeskAPI::SolutionCatogory -> solution_categories)
      def resource_name
        @resource_name ||= singular_resource_name.pluralize
      end
    end

    # Create a new resource instance.
    # @param [Client] client The client to use
    # @param [Hash] attributes The optional attributes that describe the resource
    def initialize(client, attributes = {})
      raise "Expected a Hash for attributes, got #{attributes.inspect}" unless attributes.is_a?(Hash)
      @client = client
      @attributes = attributes
    end

    # Returns the resource id of the object or nil
    def id
      attributes.key?(:id) ? attributes[:id] : nil
    end

    # Has this been object been created server-side? Does this by checking for an id.
    def new_record?
      id.nil?
    end

    # @private
    def to_s
      "#{self.class.singular_resource_name}: #{attributes.inspect}"
    end
    alias inspect to_s

    # @private
    def inspect
      "#<#{self.class.name} #{@attributes.to_hash.inspect}>"
    end

    # Compares resources by class and id. If id is nil, then by object_id
    def ==(other)
      return true if other.object_id == object_id

      if other && !other.is_a?(Data)
        warn "Trying to compare #{other.class} to a Resource from #{caller.first}"
      end

      if other.is_a?(Data)
        other.id && other.id == id
      else
        false
      end
    end
  end

  # Represents a resource that can CRUD (create, read, update, destroy)
  class Resource < Data
    include Create
    extend  Read
    include Update
    include Destroy
  end
end
