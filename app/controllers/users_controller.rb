class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:index, :new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      auto_login(@user)
      redirect_to root_url, :notice => "Signed up."
    else
      render :new
    end
  end

  def show
    redirect_to edit_user_url(current_user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user), :notice => "Updated."
    end
  end

  def destroy
  end

end
