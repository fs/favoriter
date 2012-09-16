class BoxesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @twitter_stream = current_user.cached_twitter_stream
  end
end