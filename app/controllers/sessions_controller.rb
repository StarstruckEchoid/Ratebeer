class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user&.authenticate(params[:password])
      redirect_to(signin_path, notice: "User has been banned. Please contact administration.") && return if user.banned?

      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root, notice: "Sign out successful."
  end

  def create_oauth
    info = request.env["omniauth.auth"].info
    username = info.nickname
    user = User.find_by username: username
    if user.nil?
      passwd = SecureRandom.urlsafe_base64(20)
      user = User.create username: username, password: passwd, password_confirmation: passwd
    end
    session[:user_id] = user.id
    redirect_to user_path(user), notice: "Welcome to Ratebeer, #{user.username}!"
  end
end
