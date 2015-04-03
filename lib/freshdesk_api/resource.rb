require 'freshdesk_api/actions'

module FreshdeskAPI
  # Represents a resource that only holds data.
  class Data
    # @return [Hash] The resource's attributes
    attr_reader :attributes

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

  end

  # Represents a resource that can CRUD (create, read, update, destroy)
  class Resource < Data
    include Create
    extend  Read
    include Update
    include Destroy
  end

end
