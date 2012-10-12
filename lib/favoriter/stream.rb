module Favoriter
  class Stream
    def initialize(user)
      @user = user
    end

    def pull
      result = []

      twitter_activity.each do |tweet|
        case tweet.class.name
        when 'Twitter::Action::Retweet'
          tweet.target_objects.each {|target| result << Tweet::Retweet.new(target, tweet.targets) }
        when 'Twitter::Action::Favorite'
          tweet.targets.each {|target| result << Tweet::Favorite.new(target, tweet.sources) }
        end
      end

      result
    end

    def cached_pull
      Rails.cache.fetch([:stream, @user.uid], :expires_in => 1.hour) do
        pull
      end
    end

    private

    def twitter
      @twitter ||= Twitter::Client.new(
        :oauth_token => @user.twitter_oauth_token,
        :oauth_token_secret => @user.twitter_oauth_token_secret
      )
    end

    def twitter_activity
      twitter.activity_by_friends
    end
  end
end