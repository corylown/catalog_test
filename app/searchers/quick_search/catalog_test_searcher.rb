module QuickSearch
  class CatalogTestSearcher < QuickSearch::Searcher

    def search
      resp = @http.get(base_url, parameters)
      @response = JSON.parse(resp.body)
    end

    def results
      if results_list
        results_list

      else
        @results_list = []

        @response['response']['docs'].each do |value|
          result = OpenStruct.new
          result.title = value['title_main']
          result.link = build_link(value['id'])
          result.author = value.fetch('statement_of_responsibility_a', []).join('; ')
          @results_list << result
        end

        @results_list
      end

    end

    def base_url
      "https://find.library.duke.edu/catalog.json"
    end

    def parameters
      {
        'search_field' => 'all_fields',
        'q' => http_request_queries['not_escaped'],
        'rows' => @per_page,
      }
    end

    def total
      @response['response']['total_count']
    end

    def loaded_link
      "https://find.library.duke.edu/?search_field=all_fields&q=" + http_request_queries['uri_escaped']
    end

    def build_link(id)
      "https://find.library.duke.edu/catalog/#{id}"
    end
  end
end
