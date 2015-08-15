class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if session[:user_id]
      User.find(session[:user_id]).add_provider(auth_hash)
      render :text => "You can now log in using #{auth_hash["provider"].capitalize} too!"
    else
      auth = Authorization.find_or_create(auth_hash)
      session[:user_id] = auth.user.id
      render :text => "Welcome #{auth.user.name}"
    end
  end

  def destroy
    session[:user_id] = nil
    render :text => "Logged Out"
  end

  def failure
    render :text => "Sorry try again later"
  end
end
