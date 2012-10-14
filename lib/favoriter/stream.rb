require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/fiber_iterator'

module Favoriter
  class Stream
    TWEET_TYPES = ['Twitter::Action::Favorite']

    cattr_accessor :pool_size
    self.pool_size = 50

    def initialize(user)
      @user = user
    end

    def results
      return @results if @results.present?

      @results = []

      EM.synchrony do
        EM::Synchrony::FiberIterator.new(twitter_activity, pool_size).each do |activity|

          activity.targets.each do |target|
            tweet = Favoriter::Tweet::Favorite.new(target, activity.sources)
            tweet.content_prepare if tweet.content_has_link?

            @results << tweet
          end if TWEET_TYPES.include?(activity.class.name)
        end

        EM.stop
      end

      @results
    end

    def cached_results
      Rails.cache.fetch([:stream, @user.uid], expires_in: 1.hour) do
        results
      end
    end

    private

    def twitter
      @twitter ||= Twitter::Client.new(
        oauth_token: @user.twitter_oauth_token,
        oauth_token_secret: @user.twitter_oauth_token_secret
      )
    end

    def twitter_activity
      twitter.activity_by_friends
    end
  end
end