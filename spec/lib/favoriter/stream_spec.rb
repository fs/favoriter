require 'spec_helper'

describe Favoriter::Stream, use_vcr_cassette('tweets') do
  let(:user) do
    double('User',
      twitter_oauth_token: 'token',
      twitter_oauth_token_secret: 'token'
    )
  end

  let(:stream) { Favoriter::Stream.new(user) }
  subject { stream }

  describe '#results', use_vcr_cassette('tweets') do
    before do
      Favoriter::Tweet::Favorite.any_instance.stub(:content_prepare)
    end

    subject { stream.results }
    its(:size) { should == 28 }
  end
end