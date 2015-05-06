require 'freshdesk_api'
require 'webmock'

begin
  require 'byebug'
rescue LoadError
end

require File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_resources')

def client
  credentials = File.join(File.dirname(__FILE__), '..', 'fixtures', 'credentials.yml')
  @client ||= begin
    client = FreshdeskAPI::Client.new do |config|
      if File.exists?(credentials)
        data = YAML.load(File.read(credentials))
        config.username = data["username"]
        config.password = data["password"]
        config.base_url = data["base_url"]
      else
        STDERR.puts "add your credentials to spec/fixtures/credentials.yml (see: spec/fixtures/credentials.yml.example)"
      end
    end

    client
  end
end

module TestHelper
  def json(body = {})
    MultiJson.dump(body)
  end

  def stub_json_request(verb, path_matcher, body = json, options = {})
    stub_request(verb, path_matcher).to_return({
      body: body,
      headers: {
        content_type: :json,
        content_length: body.size
      }
    }.deep_merge(options))
  end

end

RSpec.configure do |c|
  c.after(:each) do
    WebMock.reset!
  end

  c.include TestHelper
end

include WebMock::API
