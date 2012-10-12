module Favoriter::Tweet
  class Base
    attr_reader :target, :sources

    delegate :type, :image, :title, :excerpt, :text,
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

    def producer_names
      @producer_names ||= sources.map { |s| s.name }.join(', ')
    end

    def producer_screen_names
      @producer_screen_names ||= sources.map { |s| s.screen_name }.join(', ')
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