# frozen_string_literal: true

module FreshdeskAPI
  # Holds the configuration options for the client and connection
  class Configuration
    # @return [String] The basic auth username
    attr_accessor :username

    # @return [String] The basic auth password.
    attr_accessor :password

    # @return [String] The basic auth token.
    attr_accessor :apitoken

    # @return [String] The API url. Must be https unless {#allow_http} is set.
    attr_accessor :base_url

    # @return [Logger] Logger to use when logging requests.
    attr_accessor :logger

    # @return [Hash] Client configurations
    attr_accessor :client_options

    # @return [Boolean] Whether to allow non-HTTPS connections for development purposes.
    attr_accessor :allow_http

    # :read_timeout and :open_timeout are how long to wait for a response and
    # to open a connection, in seconds. Pass nil to disable the timeout.
    attr_accessor :open_timeout
    attr_accessor :read_timeout

    def initialize
      @client_options = {}
    end

    # Sets accept and user_agent headers, and url
    #
    # @return [Hash] RestClient-formatted hash of options.
    def options
      {
        headers: {
          accept: :json,
          content_type: :json,
          accept_encoding: 'gzip ,deflate',
          user_agent: "FreshdeskAPI API #{FreshdeskAPI::VERSION}"
        },
        read_timeout: nil,
        open_timeout: nil,
        base_url: @base_url
      }.merge(client_options)
    end
  end
end
