module FreshdeskAPI
  # Represents a collection of resources
  class Collection
    attr_reader :resources
    attr_reader :resource_class

    # Creates a new Collection instance. Does not fetch resources.
    # @param [Client] client The {Client} to use.
    # @param [String] resource The resource being collected.
    # @param [Hash] options Any additional options to be passed in.
    def initialize(client, resource, options = {})
      @client = client
      @resource_class = resource
      @resource = resource.resource_name
      @options = options
    end

    # The API path to this collection
    def path
      @resource_class.api_url(@options)
    end

    # Execute actual GET from API and load resources into proper class.
    # # @return [Array] All resource
    def all!(options = {})
      @options.merge!(options)

      response = get_response(path)
      handle_response(response.body)

      @resources
    end

    def get_response(path)
      @client.connection[path].send(:get, @options)
    end

    def handle_response(response_body)
      results = MultiJson.load(response_body, symbolize_keys: true)

      if results.is_a?(Hash)
        results = FreshdeskAPI::Helpers.deep_hash_access(results, @resource_class.collection_namespace)
      elsif results.is_a?(Array)
        results = results.map { |r| r[@resource_class.collection_namespace.to_sym] }
      else
        raise "Expected a Hash or Array for response body, got #{result.inspect}"
      end

      @resources = results.map do |res|
        wrap_resource(res)
      end
    end

    def wrap_resource(res)
      @resource_class.new(@client, res)
    end

    # @private
    def to_s
      if @resources
        @resources.inspect
      else
        inspect = []
        inspect << "options=#{@options.inspect}" if @options.any?
        "#{@resource.singularize} collection [#{inspect.join(',')}]"
      end

    end
    alias :inspect :to_s

  end

end
