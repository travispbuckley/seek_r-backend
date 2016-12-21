class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new
    @user = User.new
  end

  def create
             p params
            # p 'http post request made to users create'
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render :json => { session: session }.to_json, status: :created, :message => "TEAM SPIRIT!"
    else
      @errors = @user.errors.full_messages
      render :json => { errors: @errors }.to_json, status: :unprocessable_entity
    end
  end

  # def show
  #   @user = User.find(params[:id])
  #   # @categories = Category.all
  #   @users = User.all
  # end

  def update
    @user = User.find(params[:id])
    @user.save
    # respond_to do |format|
    #     format.html { redirect_to @user }
    # end
  end

  def show
    user = User.find_by(username: params[:id])
    you = User.find(session[:user])
    p '%%%%%SHOW USER%%%%%%'
    p user
    render :json => {user:{n: user.public_key_n, e:user.public_key_e, your_n: you.public_key_n, your_e: you.public_key_e}}.to_json, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :public_key_n,:public_key_e)
  end

end
