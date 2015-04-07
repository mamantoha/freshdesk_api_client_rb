module FreshdeskAPI

  module ResponseHandler
    def handle_response(response)
      response = MultiJson.load(response, symbolize_keys: true)
      @attributes.replace(@attributes.deep_merge(response[response_namespace]))
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

      new(client).tap do |resource|
        resource.handle_response(response)
      end
    end
  end

  module Save
    include ResponseHandler

    # Create or save resource.
    # Executes a POST if it is a {Data#new_record?}, otherwise a PUT.
    def save!(options = {})
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
    end
  end

  module Update
    include Save

    def self.included(base)
      base.extend(ClassMethods)
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
    end
  end

  module Destroy
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def destroy!
      path = api_url + "/#{id}"
      @client.make_request!(path, :delete)
    end

    module ClassMethods
      def destroy!(client, attributes = {}, &block)
        new(client, attributes).destroy!(&block)
      end
    end

  end
end
