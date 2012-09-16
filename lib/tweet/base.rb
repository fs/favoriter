require 'rinku'

module Tweet
  class Base
    attr_reader :target, :sources

    def initialize(target, sources)
      @target, @sources = target, sources
    end

    def text
      target.text
    end

    def text_with_links
      @text_with_links ||= Rinku.auto_link(target.text)
    end

    def user_name
      target.user.name
    end

    def user_screen_name
      target.user.screen_name
    end

    def user_image_url
      target.user.profile_image_url
    end

    def producer_names
      @producer_names ||= sources.map { |s| s.name }.join(', ')
    end

    def producer_screen_names
      @producer_screen_names ||= sources.map { |s| s.screen_name }.join(', ')
    end
  end
end