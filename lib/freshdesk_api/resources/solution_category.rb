# frozen_string_literal: true

require 'freshdesk_api/resource'

module FreshdeskAPI
  class SolutionCategory < Resource
    def api_url(_options = {})
      '/solution/categories'
    end

    def request_namespace
      'solution_category'
    end

    def response_namespace
      :category
    end

    class << self
      def api_url(_options = {})
        '/solution/categories'
      end

      def collection_namespace
        'category'
      end
    end
  end
end
