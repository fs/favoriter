module ApplicationHelper
  def render_tweets(tweets)
    tweets.each do |tweet|
      render partial: tweet.content_type,
        layout: 'tweet',
        locals: { tweet: tweet }
    end
  end
end
