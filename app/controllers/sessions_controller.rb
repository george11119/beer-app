class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back, #{params[:username]}!"
    else
      redirect_to signin_path, notice: "Username or password is incorrect"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
