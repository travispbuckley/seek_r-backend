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
    if @message.save
      p "%%%%%%%SUCCESSFUL MESSAGE CREATION%%%%%%"
    else
      p '$$$$$$$$didntpostmessage$$$$$$$$$$'
      p @message.errors.full_messages
    end
  end
end
