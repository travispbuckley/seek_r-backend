class SessionsController < ApplicationController
skip_before_action :verify_authenticity_token
  def create
    # p paramss
    @user = User.find_by(username: params[:user][:username])
    p params
    p @user
    if @user && @user.authenticate(params[:user][:password])

      session[:user] = @user.id
      session[:session] = session[:session_id]
      render :json => {data: session}
      # redirect_to root_path
    else
      p '$$$$$$$$$$$$$$$$$$'
      p params
      @errors = ['Invalid combination']
      # render "new"
    end
  end

  def check
    p logged_in?
    # redirect_to root_path
    p session
    render :json => session
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
