require 'rest_client'
require 'multi_json'
require 'deep_merge'
require 'pry'

require 'freshdesk_api/version'
require 'freshdesk_api/configuration'
require 'freshdesk_api/resource'

# Supported API resources
require 'freshdesk_api/resources/solution_category'
require 'freshdesk_api/resources/solution_folder'
require 'freshdesk_api/resources/solution_article'


module FreshdeskAPI
  # The top-level class that handles configuration and connection to the Freshdesk API.
  class Client
    # @return [Configuration] Config instance
    attr_reader :config

    # Creates a new {Client} instance and yields {#config}.
    #
    # Requires a block to be given.
    #
    # Does basic configuration constraints:
    # * {Configuration#base_url} must be https unless {Configuration#allow_http} is set.
    def initialize
      raise ArgumentError, 'block not given' unless block_given?

      @config = FreshdeskAPI::Configuration.new

      yield config

      check_url
      set_default_logger
    end

    # Creates a connection if there is none, otherwise returns the existing connection.
    #
    # @return [RestClient::Resouce] RestClient connection for the client
    def connection
      @connection ||= build_connection
    end

    protected

    # Called by {#connection} to build a connection.
    #
    # Request logger if logger is not nil
    def build_connection
      RestClient::Resource.new(config.base_url, config.options.merge(auth_options))
    end

    # HTTP Basic Authentication credentials
    def auth_options
      { user: config.username, password: config.password }
    end

    private

    def check_url
      if !config.allow_http && config.base_url !~ /^https/
        raise ArgumentError, "freshdesk_api is ssl only; url must begin with https://"
      end
    end

    def set_default_logger
      if config.logger.nil? || config.logger == true
        require 'logger'
        config.logger = Logger.new($stderr)
        config.logger.level = Logger::WARN
      end
    end

  end
end
