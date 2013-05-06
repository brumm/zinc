class UserSessionsController < ApplicationController

  skip_before_filter :require_login, except: [:destroy]

  def new
    session[:return_to] ||= request.referer
    redirect_back_or_to root_url if current_user
  end

  def create
    @user = login(params[:username], params[:password])
    if @user
      redirect_to session[:return_to]
    else
      flash.now.alert = "Something went oops."
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out."
  end

end
