require 'favoriter/stream'

class BoxesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tweets = Favoriter::Stream.new(current_user).fetch
  end
end