require 'spec_helper'

describe SessionsController do
  let(:current_user) { create :user }

  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = {
        'uid' => current_user.uid,
        'provider' => current_user.provider,
        'info' => {
          'name' => current_user.name
        },
        'credentials' => {
          'token' => 'token',
          'secret' => 'secret'
        }
      }
  end

  describe 'GET #new' do
    it 'redirectes users to authentication' do
      get 'new'
      assert_redirected_to '/auth/twitter'
    end
  end

  describe 'creates new user' do
    it 'redirects users back to root_url' do
      visit '/signin'
      page.should have_content('Signed in!')
      current_path.should == '/'
    end
  end
end
