require 'freshdesk_api/resource'

module FreshdeskAPI
  class SolutionFolder < Resource
    # Need to specify category_id in url

    def api_url(options = {})
      "/solution/categories/%{category_id}/folders" % attributes
    end

    def request_namespace
      'solution_folder'
    end

    def response_namespace
      :folder
    end

    class << self
      def api_url(options = {})
        "/solution/categories/%{category_id}/folders" % options
      end
    end

  end
end
