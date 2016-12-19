class MessagesController < ApplicationController
skip_before_action :verify_authenticity_token
  def index
    @you = User.find(session[:user])
    @conversations = []
    Message.where(sender_id: @you.id).each do |message|
      @conversations += [User.find(message.receiver_id).username]
    end
    Message.where(receiver_id: @you.id).each do |message|
      @conversations += [User.find(message.sender_id).username]
    end
    @conversations = Hash[@conversations.uniq.map.with_index { |value, index| [index, value] }]
    render :json => {data: {conversations: @conversations}}
  end

  def create
    # p paramss
    @receiver = User.find_by(username: params[:message][:receiver])
    @sender = User.find(session[:user])
    @conversation
    @message = Message.new(sender_id:@sender.id,receiver_id:@receiver.id,body:params[:message][:body])
    @message.location = params[:message][:location] # this is optional; may need to specify or nil/string
    if @message.save
      p "%%%%%%%SUCCESSFUL MESSAGE CREATION%%%%%%"
    else
      p '$$$$$$$$didntpostmessage$$$$$$$$$$'
      p @message.errors.full_messages
    end
  end

  def show
    user = User.find_by(username:params[:id])
    you = User.find(session[:user])
    messages = Message.where(sender_id:[you.id,user.id], receiver_id: [user.id,you.id]).order(:created_at)
    p messages
    messages_bodies = messages.map do |message|
        message.sender.username + ": " + message.body
    end
    p messages_bodies
    p user.username
    render :json => {data: {messages: messages_bodies}}
  end
end
