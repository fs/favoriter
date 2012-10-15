class HomeController < ApplicationController
  before_filter :require_no_user!

  def index
  end
end
