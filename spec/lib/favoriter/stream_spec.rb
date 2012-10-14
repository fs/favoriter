require 'spec_helper'

describe Favoriter::Stream, use_vcr_cassette('tweets') do
  let(:user) do
    double('User',
      uid: 1,
      twitter_oauth_token: 'token',
      twitter_oauth_token_secret: 'token'
    )
  end

  let(:stream) { Favoriter::Stream.new(user) }
  subject { stream }

  describe '#fetch', use_vcr_cassette('tweets') do
    before do
      Favoriter::Tweet::Favorite.any_instance.stub(:content_prepare)
      stream.fetch
    end

    describe '#tweets' do
      subject { stream.tweets }
      its(:size) { should == 28 }
    end

    describe 'tweets with links' do
      subject { stream.tweets_with_links_idx }
      its(:size) { should == 15 }
    end
  end
end