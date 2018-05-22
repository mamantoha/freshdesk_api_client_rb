# frozen_string_literal: true

require 'freshdesk_api'
require 'webmock/rspec'

begin
  require 'byebug'
rescue LoadError
end

require File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_resources')

def fake_client
  credentials = File.join(File.dirname(__FILE__), '..', 'fixtures', 'credentials.yml')
  @client ||= begin
    client = FreshdeskAPI::Client.new do |config|
      data = YAML.safe_load(File.read(credentials))
      config.username = data['username']
      config.password = data['password']
      config.base_url = data['base_url']
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
