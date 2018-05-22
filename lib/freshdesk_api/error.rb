# frozen_string_literal: true

module FreshdeskAPI
  module Error
    class ClientError < StandardError; end

    class RecordInvalid < ClientError
      attr_accessor :response, :errors

      def initialize(response)
        @response = response
      end

      def to_s
        "#{self.class.name}: #{@errors}"
      end
    end

    class NotAcceptable < ClientError; end
    class ResourceNotFound < ClientError; end
    class NetworkError < ClientError; end
  end
end
