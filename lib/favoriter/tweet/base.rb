require 'favoriter/tweet/content'

module Favoriter::Tweet
  class Base
    attr_reader :target, :sources

    delegate :has_link?, :prepare, :type, :image, :title, :excerpt, :text, :url,
      to: :content,
      prefix: true

    delegate :name, :screen_name, :profile_image_url,
      to: :target_user,
      prefix: :user

    def initialize(target, sources)
      @target, @sources = target, sources
    end

    def user_url
      twitter_url(user_screen_name)
    end

    def producer_screen_names
      @producer_screen_names ||= sources.map { |s| %Q{<a href="#">#{s.screen_name}</a>} }.join(', ').html_safe
    end

    private

    def content
      @content ||= Favoriter::Tweet::Content.new(target.text)
    end

    def twitter_url(name)
      "https://twitter.com/#{name}"
    end

    def target_user
      target.user
    end
  end
end