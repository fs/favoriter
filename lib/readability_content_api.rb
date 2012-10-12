require 'httparty'

class ReadabilityContentAPI
  include HTTParty
  base_uri 'https://readability.com/api/content/v1/parser'

  def initialize(token)
    self.class.default_params :token => token
  end

  def parse(url, options = {})
    options = {query: {
      url: url,
      max_pages: 1
    }}

    self.class.get('/', options).parsed_response
  end

  def cached_parse(url, options = {})
    Rails.cache.fetch([:readability, Digest::MD5.hexdigest(url)], :expires_in => 1.hour) do
      parse(url, options)
    end
  end
end
