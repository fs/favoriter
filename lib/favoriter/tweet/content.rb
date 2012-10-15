require 'uri'
require 'favoriter/tweet/readability_parser'

module Favoriter::Tweet
  class Content
    attr_accessor :parsed_content

    def initialize(text)
      @text = text
    end

    def has_link?
      @has_link ||= link_urls.size > 0
    end

    def type
      with_link_and_prepared_content('text') do
        return 'image' if link_url_is_image? || link_url_is_page_with_image_only?
        return 'article_with_image' if link_url_is_article_with_image?
        return 'article_without_image' if link_url_is_article?

        'text'
      end
    end

    def image
      with_link_and_prepared_content do
        return parsed_content['url'] if link_url_is_image?
        return parsed_content['lead_image_url'] if link_url_is_page_with_image_only?
        return parsed_content['lead_image_url'] if link_url_is_article_with_image?
      end
    end

    def title
      with_link_and_prepared_content do
        clean_links(parsed_content['title']) if link_url_is_article? || link_url_is_page_with_image_only?
      end
    end

    def excerpt
      with_link_and_prepared_content do
        parsed_content['excerpt'].html_safe if link_url_is_article?
      end
    end

    def text
      clean_links(@text)
    end

    def url
      with_link_and_prepared_content do
        parsed_content['url']
      end
    end

    def prepare
      self.parsed_content = Favoriter::Tweet::ReadabilityParser.new(link_url).cached_content
    end

    private

    def link_url
      link_urls.first
    end

    def link_urls
      @link_urls ||= URI.extract(@text, ['http', 'https'])
    end

    def link_url_is_article?
      parsed_content['title'].present? && parsed_content['word_count'] > 0
    end

    def link_url_is_article_with_image?
      return false unless link_url_is_article?
      parsed_content['lead_image_url'].present?
    end

    def link_url_is_page_with_image_only?
      parsed_content['lead_image_url'].present? && parsed_content['word_count'] == 0
    end

    def link_url_is_image?
       link_url_media_type == 'image'
    end

    def link_url_media_type
      return 'text' if parsed_content['url'].blank?

      mime_types =  MIME::Types.of(parsed_content['url'])

      return 'text' if mime_types.blank?
      return MIME::Type.new(mime_types.first).media_type
    end

    def with_link_and_prepared_content(default_value = nil)
      return yield if has_link? && content_prepared?
      default_value
    end

    def content_prepared?
      parsed_content.present?
    end

    def clean_links(text)
      text.gsub(/(?:f|ht)tps?:\/[^\s]+/, '').strip
    end
  end
end