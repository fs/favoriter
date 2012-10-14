require 'em-http/middleware/json_response'

module Favoriter::Tweet
  class ReadabilityParser
    cattr_accessor :token
    self.token = ENV['READABILITY_KEY']

    cattr_accessor :base_uri
    self.base_uri = 'https://readability.com/api/content/v1/parser'

    cattr_accessor :cache_ttl
    self.cache_ttl = 12.hours

    def initialize(url)
      @url = url
    end

    def content
      EventMachine::HttpRequest.use EventMachine::Middleware::JSONResponse

      response = EventMachine::HttpRequest.new(api_url(@url)).get.response
      response.delete('content')
      response
    end

    def cached_content
      Rails.cache.fetch(cache_key(@url), expires_in: cache_ttl) do
        content
      end
    end

    private

    def api_url(url)
      options = {
        token: token,
        url: url,
        max_pages: 1
      }

      "#{base_uri}?#{options.to_query}"
    end

    def cache_key(url)
      [:readability, Digest::MD5.hexdigest(url)]
    end
  end
end