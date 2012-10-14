require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/fiber_iterator'

module Favoriter
  class Stream
    TWEET_TYPES = ['Twitter::Action::Favorite']

    cattr_accessor :pool_size
    self.pool_size = 15

    cattr_accessor :cache_ttl
    self.cache_ttl = 1.hour

    attr_reader :tweets, :tweets_with_links_idx

    def initialize(user)
      @user = user
    end

    def fetch
      @tweets = []
      @tweets_with_links_idx = []

      cached_twitter_activity.each do |activity|
        next unless TWEET_TYPES.include?(activity.class.name)

        activity.targets.each do |target|
          tweet = Favoriter::Tweet::Favorite.new(target, activity.sources)

          @tweets_with_links_idx << @tweets.size if tweet.content_has_link?
          @tweets << tweet
        end
      end

      EM.synchrony do
        EM::Synchrony::FiberIterator.new(@tweets_with_links_idx, pool_size).each do |index|
          tweet = @tweets[index]
          tweet.content_prepare

          @tweets[index] = tweet
        end

        EM.stop
      end

      @tweets
    end

    def cached_results
      Rails.cache.fetch([:stream, @user.uid], expires_in: cache_ttl) do
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

    def cached_twitter_activity
      Rails.cache.fetch([:twitter_activity, @user.uid], expires_in: cache_ttl) do
        twitter_activity
      end
    end
  end
end