require 'uri'
require 'awesome_print'

class Favoriter::Tweet::Content
  def initialize(text)
    @text = text
  end

  def type
    return 'text' unless has_links?
    return 'image' if url_is_image?
    return 'article_with_image' if url_is_article_with_image?
    return 'article_without_image' if url_is_article?

    'text'
  end

  def image
    return nil unless has_links?
    return parsed_content['url'] if url_is_image?
    return parsed_content['lead_image_url'] if url_is_article_with_image?
  end

  def title
    return nil unless has_links?
    return parsed_content['title'] if url_is_article?
  end

  def excerpt
    return nil unless has_links?
    return parsed_content['excerpt'].html_safe if url_is_article?
  end

  def text
    @text.gsub(/(?:f|ht)tps?:\/[^\s]+/, '').strip
  end

  private

  def url_is_article?
    parsed_content['title'].present? && parsed_content['word_count'] > 0
  end

  def url_is_article_with_image?
    return false unless url_is_article?
    parsed_content['lead_image_url'].present?
  end

  def url_is_image?
     media_type == 'image'
  end

  def media_type
    return 'text' if parsed_content['url'].blank?

    mime_types =  MIME::Types.of(parsed_content['url'])

    return 'text' if mime_types.blank?
    return MIME::Type.new(mime_types.first).media_type
  end

  def parsed_content
    @parsed_content ||= ReadabilityContentAPI.new(ENV['READABILITY_KEY']).cached_parse(url)
  end

  def url
    @url ||= urls.first
  end

  def urls
    @urls ||= URI.extract(@text, ['http', 'https'])
  end

  def has_links?
    urls.size > 0
  end
end