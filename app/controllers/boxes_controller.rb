class BoxesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @twitter_stream = Favoriter::Stream.new(current_user).cached_pull
  end
end