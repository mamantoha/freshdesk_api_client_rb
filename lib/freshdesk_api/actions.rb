module FreshdeskAPI

  module ResponseHandler
    def handle_response(response)
      response = MultiJson.load(response, symbolize_keys: true)
      if response[response_namespace]
        @attributes.replace(@attributes.deep_merge(response[response_namespace]))
      end
    end
  end

  module Read
    def self.extended(klass)
      klass.send(:include, ResponseHandler)
    end

    # Finds a resource by an id and any options passed in
    # @param [Client] client The {Client} object to be used
    # @param [Hash] option Any additional GET parameters to be added
    def find!(client, options = {})
      @client = client # so we can use client.logger in rescue
      raise ArgumentError, 'No :id given' unless options[:id]

      path = api_url(options) + "/#{options[:id]}"

      response = client.make_request!(path, :get)

      new(@client).tap do |resource|
        resource.attributes.merge!(options)
        resource.handle_response(response)
      end
    end

    # Finds, returning nil if it fails
    def find(client, options = {}, &block)
      find!(client, options, &block)
    rescue FreshdeskAPI::Error::ClientError => e
      nil
    end
  end

  module Save
    include ResponseHandler

    # If this resource hasn't been deleted, then create or save it.
    # Executes a POST if it is a {Data#new_record?}, otherwise a PUT.
    # @return [Resource] created or updated object
    def save!(options = {})
      return false if respond_to?(:destroyed?) && destroyed?

      options = { request_namespace => attributes }

      if new_record?
        method = :post
        req_path = api_url(options)
      else
        method = :put
        req_path = api_url(options) + "/#{id}"
      end

      response = @client.make_request!(req_path, method, options)

      handle_response(response)
      return self
    end

    # Saves, returning false if it fails and attachibg the errors
    def save(options = {}, &block)
      save!(options, &block)
    rescue FreshdeskAPI::Error::RecordInvalid => e
      @errors = e.errors
      false
    rescue FreshdeskAPI::Error::ClientError
      false
    end
  end

  module Create
    include Save

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Create a resource given the attributes passed in.
      # @param [Client] client The {Client} object to be used
      # @param [Hash] attributes The attributes to create.
      def create!(client, attributes = {}, &block)
        response = nil
        new(client, attributes).tap do |resource|
          response = resource.save!(&block)
        end

        response
      end

      # Create a resource, returning nil if it fails
      def create(client, attributes = {}, &block)
        create!(client, attributes, &block)
      rescue FreshdeskAPI::Error::ClientError
        nil
      end
    end
  end

  module Update
    include Save

    def self.included(base)
      base.extend(ClassMethods)
    end

    def update!(attributes = {})
      self.attributes.merge!(attributes)
      self.save!
    end

    def update(attributes = {})
      update!(attributes = {})
    rescue FreshdeskAPI::Error::ClientError
      false
    end

    module ClassMethods
      # Updates a resource given the id passed in
      # @params [Client] client The {Client} object to be used
      # @param [Hash] attributes The attributes to update. Default to {}
      def update!(client, attributes = {}, &block)
        response = nil
        new(client, id: attributes.delete(:id)).tap do |resource|
          resource.attributes.merge!(attributes)
          response = resource.save!(&block)
        end

        response
      end

      # Updates a resource, returning nil if it fails
      def update(client, attributes = {}, &block)
        update!(client, attributes, &block)
      rescue FreshdeskAPI::Error::ClientError
        false
      end
    end
  end

  module Destroy
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    # Has this object been deleted?
    def destroyed?
      @destroyed ||= false
    end

    # If this resource hasn't already been deleted, then do so.
    # instance method
    # @return [Boolean] Success?
    def destroy!
      return false if destroyed? || new_record?

      path = api_url + "/#{id}"
      @client.make_request!(path, :delete)

      @destroyed = true
    end

    # instance method
    def destroy
      destroy!
    rescue FreshdeskAPI::Error::ClientError
      false
    end

    module ClassMethods
      # Deteles a resource given the id passed in.
      # @params [Client] client The {Client} object to be used
      # @param [Hash] attributes The optional parameters to pass. Defaults to {}
      def destroy!(client, attributes = {}, &block)
        new(client, attributes).destroy!(&block)
        true
      end

      def destroy(client, attributes = {}, &block)
        destroy!(client, attributes, &block)
      rescue FreshdeskAPI::Error::ClientError
        false
      end
    end

  end
end
