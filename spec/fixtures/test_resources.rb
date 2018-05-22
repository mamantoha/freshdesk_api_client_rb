# frozen_string_literal: true

module FreshdeskAPI
  class TestResource < FreshdeskAPI::Resource
    def self.test(_client)
      'hi'
    end

    def api_url(_options = {})
      '/test/resources'
    end

    def request_namespace
      'test_resource'
    end

    def response_namespace
      :resource
    end

    class << self
      def api_url(_options = {})
        '/test/resources'
      end

      def collection_namespace
        'resource'
      end
    end

    class TestChild < FreshdeskAPI::Resource
    end
  end
end
