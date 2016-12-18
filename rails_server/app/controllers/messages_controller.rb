class MessagesController < ApplicationController
skip_before_action :verify_authenticity_token
  def create
    # p paramss
    @receiver = User.find_by(username: params[:message][:receiver])
    @sender = User.find(session[:user])
    @message = Message.new(sender_id:@sender.id,receiver_id:@receiver.id,body:params[:message][:body])
    if @message.save
      p "%%%%%%%SUCCESSFUL MESSAGE CREATION%%%%%%"
    else
      p '$$$$$$$$didntpostmessage$$$$$$$$$$'
      p @message.errors.full_messages
    end
  end
end
