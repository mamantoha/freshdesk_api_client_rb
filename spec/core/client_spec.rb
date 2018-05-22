# frozen_string_literal: true

require 'core/spec_helper'

describe FreshdeskAPI::Client do
  subject { client }

  context '#initialize' do
    it 'should require a block' do
      expect { FreshdeskAPI::Client.new }.to raise_error(ArgumentError)
    end

    it "should raise an exception when url isn't ssl" do
      expect do
        FreshdeskAPI::Client.new do |config|
          config.base_url = 'http://freshdesk.com'
        end
      end.to raise_error(ArgumentError)
    end

    it 'should handle valid url' do
      expect do
        FreshdeskAPI::Client.new do |config|
          config.base_url = 'https://me.freshdesk.com'
        end
      end.to_not raise_error
    end
  end
end
