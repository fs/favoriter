require 'spec_helper'

describe Favoriter::Stream, { vcr: { cassette_name: 'tweets' } } do
  let(:user) do
    double('User',
      twitter_oauth_token: ENV['TWITTER_OAUTH_TOKEN'],
      twitter_oauth_token_secret: ENV['TWITTER_OAUTH_SECRET']
    )
  end

  let(:stream) { Favoriter::Stream.new(user) }
  subject { stream }

  describe '#pull' do
    let(:pull_response) { stream.pull }
    subject { pull_response }

    it { should_not be_empty }
    its(:size) { should == 37 }

    describe 'first item' do
      subject { pull_response.first }
      it { should be_a_kind_of(Favoriter::Tweet::Favorite)}
    end
  end
end