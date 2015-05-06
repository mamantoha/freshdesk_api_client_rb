class FreshdeskAPI::TestResource < FreshdeskAPI::Resource
  def self.test(client)
    'hi'
  end

  def api_url(options = {})
    "/test/resources"
  end

  def request_namespace
    'test_resource'
  end

  def response_namespace
    :resource
  end

  class << self
    def api_url(options = {})
      "/test/resources"
    end

    def collection_namespace
      'resource'
    end
  end

  class TestChild < FreshdeskAPI::Resource
  end
end
