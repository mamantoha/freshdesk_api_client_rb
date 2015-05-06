require 'core/spec_helper'

describe FreshdeskAPI::Configuration do
  subject { FreshdeskAPI::Configuration.new }

  it "should properly merge options" do
    url = "test.host"
    subject.base_url = url
    expect(subject.options[:base_url]).to eq(url)
  end

  it "should set accept header properly" do
    expect(subject.options[:headers][:accept]).to eq(:json)
  end

  it "should set user agent header properly" do
    expect(subject.options[:headers][:user_agent]).to match(/FreshdeskAPI API/)
  end

  it "should set a default open_timeout" do
    expect(subject.options[:open_timeout]).to eq(nil)
  end

  it "should set a default read_timeout" do
    expect(subject.options[:read_timeout]).to eq(nil)
  end

  it "should change a default open_timeout" do
    subject.client_options = { open_timeout: 10 }
    expect(subject.options[:open_timeout]).to eq(10)
  end

  it "should change a default read_timeout" do
    subject.client_options = { read_timeout: 10 }
    expect(subject.options[:read_timeout]).to eq(10)
  end

  it "should merge options with client_options" do
    subject.client_options = { ssl: false }
    expect(subject.options[:ssl]).to eq(false)
  end
end
