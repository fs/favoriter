class User
  include Mongoid::Document

  field :provider, type: String
  field :uid, type: String
  field :twitter_oauth_token, type: String
  field :twitter_oauth_token_secret, type: String
  field :name, type: String

  attr_accessible :provider, :uid, :name

  TWITTER_ACTIVITIES = [Twitter::Action::Favorite, Twitter::Action::Retweet]

  def self.from_omniauth(auth)
    user = where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
    user.refresh_tokens!(auth)

    user
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name'] || '' if auth['info']
    end
  end

  def refresh_tokens!(auth)
    self.twitter_oauth_token = auth['credentials']['token']
    self.twitter_oauth_token_secret = auth['credentials']['secret']
    self.save!
  end

  def twitter
    @twitter ||= Twitter::Client.new(
      :oauth_token => twitter_oauth_token,
      :oauth_token_secret => twitter_oauth_token_secret
    )
  end

  def twitter_stream
    twitter.activity_by_friends.select {|a| TWITTER_ACTIVITIES.include?(a.class) }
  end
end
