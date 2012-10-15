class SessionsController < ApplicationController
  before_filter :require_no_user!, only: [:new, :create, :failure]
  before_filter :authenticate_user!, only: [:destroy]

  def new
    redirect_to '/auth/twitter'
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id

    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to home_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to home_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
