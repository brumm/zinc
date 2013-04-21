class UserSessionsController < ApplicationController

  skip_before_filter :require_login, except: [:destroy]

  def new
    redirect_back_or_to root_url if current_user
  end

  def create
    @user = login(params[:username], params[:password])
    if @user
      redirect_back_or_to rooms_path, :notice => "Logged in."
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
