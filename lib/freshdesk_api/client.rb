require 'active_support/core_ext/string'
require 'rest_client'
require 'multi_json'
require 'deep_merge'
# require 'pry'

require 'freshdesk_api/version'
require 'freshdesk_api/helpers'
require 'freshdesk_api/configuration'
require 'freshdesk_api/resource'
require 'freshdesk_api/collection'
require 'freshdesk_api/error'

# Supported API resources
require 'freshdesk_api/resources/solution_category'
require 'freshdesk_api/resources/solution_folder'
require 'freshdesk_api/resources/solution_article'

module FreshdeskAPI
  # The top-level class that handles configuration and connection to the Freshdesk API.
  class Client
    # @return [Configuration] Config instance
    attr_reader :config

    # Handles resources such as 'tickets'.
    # @return [Collection] Collection instance for resource
    def method_missing(method, *args, &block)
      method = method.to_s
      method_class = method_as_class(method)
      options = args.last.is_a?(Hash) ? args.pop : {}

      FreshdeskAPI::Collection.new(self, method_class, options)
    end

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

    def make_request!(path, method, options = {})
      response = nil
      connection[path].send(method, options) { |resp, req, result|
        case resp.code
        when 302
          # Connection to the server failed. Please check username/password
        when 404
          raise Error::ResourceNotFound
        when 406
          raise Error::NotAcceptable
        end
        response = resp
      }
      return response
    rescue Exception => e
      raise Error::ClientError.new(e)
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

    def method_as_class(method)
      klass_as_string = ("FreshdeskAPI::" + method.to_s.singularize.classify).constantize
    end

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
