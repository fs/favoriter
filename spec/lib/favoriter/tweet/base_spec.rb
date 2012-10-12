require 'spec_helper'

describe Favoriter::Tweet::Base do
  let(:tweet_text) { 'text' }
  let(:tweet_target) do
    double('tweet_target',
      text: tweet_text,
      user: double({
        name: 'username',
        screen_name: 'screen_name',
        profile_image_url: 'profile_image_url'
      })
    )
  end

  let(:tweet_source) { double('tweet_source') }
  let(:favorite_tweet) { Favoriter::Tweet::Base.new(tweet_target, tweet_source) }

  subject { favorite_tweet }

  it { should respond_to(:content_type) }
  it { should respond_to(:content_image) }
  it { should respond_to(:content_title) }
  it { should respond_to(:content_excerpt) }
  it { should respond_to(:content_text) }

  its('user_name') { should == 'username' }
  its('user_screen_name') { should == 'screen_name' }
  its('user_profile_image_url') { should == 'profile_image_url' }
end