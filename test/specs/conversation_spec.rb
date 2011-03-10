require File.dirname(__FILE__) + '/spec_helper'

describe "Conversation" do

  before(:each) do

    @root = Hashie::Mash.new
    @root.id = 1

    @reply = Hashie::Mash.new
    @reply.id = 2
    @reply.in_reply_to_status_id = 1

    @reply_to_reply = Hashie::Mash.new
    @reply_to_reply.in_reply_to_status_id = 2

    @twitter = Twitter::Client.new

  end

  def tweet
    t = Hashie::Mash.new
    t.id = 0
    t
  end

  it "should find 2 tweet convo" do
    sut = TweepTalk::Convos.new @twitter

    mock(@twitter).home_timeline { [tweet, @reply, tweet, @root] }

    convos = sut.convos

    convos.count.should == 1
    convos[0].should == [@reply, @root]
  end

  it "should get the home tweets" do
    pending "use to play with api"

    Twitter.configure do |config|
      config.consumer_key = '2hEjJDY3npJ1Rh82Y1Mhtw1'
      config.consumer_secret = '9qSIPPrVIY6udxBFVmprL9zcpVaEaQPmoWijkshrYh00'
      config.oauth_token = '260488693-0ky7I3MQL0qf3ScqjjLCJpf48AIrc84YjEAriiVi71'
      config.oauth_token_secret = '7hF0pWQ27NpP0eEzUIfeRebffwXHBIH3gSjmaoTcIrFQ1'
    end

    Twitter.home_timeline.take(1).each { |t| puts "#{t} - #{t.from_user}: #{t.text}" }
  end
end