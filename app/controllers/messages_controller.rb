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
    @conversations = ["No Conversations found"] if @conversations.empty?
    @conversations = Hash[@conversations.uniq.map.with_index { |value, index| [index, value] }]
    p @conversations

    render :json => {data: {conversations: @conversations}}
  end

  def create
    p "START CREATE"
    # p paramss
    @receiver = User.find_by(username: params[:message][:receiver])
    @sender = User.find(session[:user])
    @conversation
    @message = Message.new(sender_id:@sender.id,receiver_id:@receiver.id,body:params[:message][:body],your_message:params[:message][:your_message])
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
    messages_bodies = messages.map do |message|
        # message.sender.username + ": " + message.body
      if message.sender == you
        message.your_message
      else
        message.body
      end
    end
    sender_names = messages.map do |message|
      message.sender.username
    end
    send_times = messages.map do |message|
      message.created_at.to_s[/\s\S{8}/]
    end
    p send_times
    # debug: this currently grabs EITHER user's location- ideally, i would set it to the other users' location.
    location = messages.where("location != ''").last.try("location") # this grabs the last location sent (that wasn't an empty field)
    if !location.nil? # this is so location is not nil and empty... (ie. first message most likely wont have location)
      latitude = location.split(", ")[0]
      longitude = location.split(", ")[1]
    else
      latitude = 0
      longitude = 0
    end
    location = [latitude.to_f, longitude.to_f] # random note: floats appear with "123.456" in the JSON (unlike Integers)
    render :json => {data: {messages: messages_bodies,you: you.username,sender_names: sender_names, send_times: send_times}, location: location}
  end

  # Secret
# 107148485092967
# Secret
# 107148485092967
# user:ggg
# privated :365358727056417379866577191241056523184606166181446026313313
          # 365358727056417379866577191241056523184606166181446026313313


# D
# 357425951145399560358771003005851433265528922523088869277121
# N
# 581602556366472613646657444236169488555720862109075064427179
# 1090872678690970350940790675873144505168577626979549218638587
# --n--------------
# 108026972316468522782637769296779951698769240834170358465873
# ---d-------------

# D
# 175341945929451159575054870395806092554706594111417093384033
# N
# 778390917183393662878166432375325441430101550965578699632453
# 1090872678690970350940790675873144505168577626979549218638587
# --n--------------
# 108026972316468522782637769296779951698769240834170358465873
# ---d-------------
# 1090872678690970350940790675873144505168577626979549218638587
# --n--------------
# 108026972316468522782637769296779951698769240834170358465873
# ---d-------------




end
