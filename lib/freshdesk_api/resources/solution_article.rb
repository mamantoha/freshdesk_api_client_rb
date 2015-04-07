require 'freshdesk_api/resource'

module FreshdeskAPI
  class SolutionArticle < Resource
    # Need to specify the category_id and folder_id in url

    def api_url(options = {})
      "/solution/categories/%{category_id}/folders/%{folder_id}/articles" % attributes
    end

    def request_namespace
      'solution_article'
    end

    def response_namespace
      :article
    end

    class << self
      def api_url(options = {})
        "/solution/categories/%{category_id}/folders/%{folder_id}/articles" % options
      end

      def collection_namespace
        'folder/articles'
      end

    end

  end
end
